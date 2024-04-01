# Neural Search with LLM Expert

> [!INFO|label:OpenSearch Only|style:flat]
> This guide focuses on features available in OpenSearch 2.12+

This guide provides a comprehensive walkthrough on creating a Retrieval-Augmented Generation (RAG) expert system utilizing stretchy-model, OpenSearch, and OpenAI. By integrating these technologies, you'll develop an application capable of understanding and answering complex questions with context derived from its own data.

The process involves several key steps:

- **Environment Setup:** Initiating a Rails application and integrating necessary gems.
- **Configuration:** Setting credentials for OpenSearch and OpenAI.
- **Model and Pipeline Creation:** Defining models and pipelines for handling and indexing data.
- **Machine Learning Integration:** Leveraging OpenAI's GPT model for generating responses based on the retrieved context.
- **Deployment:** Deploying models and verifying the setup.
- **Ingestion:** Ingesting a git repository.
- **Interaction:** Asking questions about the data.

## Create Rails Application

```
rails new stretchy-rails-app
```

```
cd stretchy-rails-app
```

```
bundle add opensearch-ruby stretchy-model github-linguist
```

### Set Credentials

```
rails credentials:edit
```

```yaml
opensearch: 
	host: https://localhost:9200 
	user: admin 
	password: admin 
	transport_options: 
		ssl: 
		 verify: false

openai:
    openAI_key: <open_ai_key>
```

### Initialize Stretchy

_config/initializers/stretchy.rb_ 
```ruby
Stretchy.configure do |config| 
	config.client = OpenSearch::Client.new Rails.application.credentials.opensearch 
end
```

### Start OpenSearch

>[!WARNING]
>This example deploys multiple Machine Learning models and will need a node for each. Follow the [multi-node docker instructions](https://gist.github.com/esmarkowski/7f3ec9bfb3b0dc3604112b67410067e7) to ensure you can fully deploy by the end of the example. 
>

```
docker-compose -f opensearch/ml-compose.yml up
```

## Define Models

### RepoFile

*app/models/repo_file.rb*
```ruby
class RepoFile < StretchyModel
	attribute :content, :text
	attribute :file_name, :string
	attribute :embeddings, :knn_vector, dimension: 384
	
	default_pipeline :text_embedding_pipeline
	
	index_settings(
		'knn.space_type': :cosinesimil,
		knn: true
	)

end
```


### Text Embedding Model

*app/machine_learning/text_embedding_model.rb*
```ruby
class TextEmbeddingModel < Stretchy::MachineLearning::Model

  model :sentence_transformers_minilm_12
  model_format 'TORCH_SCRIPT'
  version '1.0.1'

end
```

## Ingest Pipeline 

### Text Embedding Pipeline

*app/pipelines/ingest/text_embedding_pipeline.rb*
```ruby
module Ingest
  class TextEmbeddingPipeline < Stretchy::Pipeline

    description "KNN text embedding pipeline"

    processor :text_embedding, 
      field_map: {
        content: :embeddings
      },
      model: TextEmbeddingModel

  end
end
```

## Configure LLM 

## Create a connector

```ruby
module Connectors
  class GPTConnector < Stretchy::MachineLearning::Connector

    description "The connector to OpenAI's gpt-3.5-turbo service for gpt model"
      
    version 1
    
    protocol "http"
    
    credentials Rails.application.credentials.dig(:openai)
    
    parameters endpoint: "api.openai.com",
               model: 'gpt-3.5-turbo'

    actions action_type: "predict",
            method: "POST",
            url: "https://${parameters.endpoint}/v1/chat/completions",
            headers: {
              "Authorization": "Bearer ${credential.openAI_key}"
            },
            request_body: "{\"model\":\"${parameters.model}\",\"messages\": ${parameters.messages}}"
       
  end
end
```

### Create an LLM Model

```ruby
module Models
	class GPT < Stretchy::MachineLearning::Model
	
	  model_name 'gpt'
	  function_name :remote
	  connector 'Connectors::GPTConnector'
	
	  def self.predict(prompt)
	    response = client.predict(model_id: self.model_id, body: prompt)
		response.dig('inference_results')
			.first.dig('output')
			.first.dig('dataAsMap', 'choices')
			.first.dig('message', 'content')
	  end
	end
end
```

### Define an expert

```ruby
class Expert

	BEHAVIOR = <<~DOC 
  You are an expert in Ruby, Ruby on Rails, Elasticsearch and Opensearch. 
  You read documentation and provide succinct and direct answers to the questions provided using the context provided. 
  If the answer is not directly shown in the context, you will analyze the data and find the answer. 
  If you don't know the answer, just say you don't know.
  DOC

	def get_context(question, k=2)
		RepoFile.neural(
			embeddings: question,
			model_id: TextEmbeddingModel.model_id,
			k: k
		).pluck(:content)
	end
	
	def ask(question)
		prompt = {
			parameters: {
				messages: [
					{
						"role": "system",
						"content": BEHAVIOR
					},
					{
						"role": "assistant",
						"content": get_context(question).join("\n")
					},
					{
						"role": "user",
						"content": question
					}
				]
			}
		}
		
		Models::GPT.predict(prompt)
	end
end

```

## Deploy Models

Stretchy includes rake tasks to aid in managing your resources. Running `rake stretchy:up` will ensure dependencies are handled by performing the following steps:
- Create `Connectors`
- Register and deploy `MachineLearning::Models`
- Create `Pipelines` 
- Create indexes for all `StretchyModels`

> [!INFO|style:flat|label:Machine Learning Nodes]
> If you do not have dedicated machine learning nodes (or are running a single-node cluster) you'll need to enable machine learning on all nodes. 
> 
> ```
> rake stretchy:ml_on_all_nodes
> ```
> 

Run the following to start the deployment: 

```
rake stretchy:up
```

![rake](../media/stretchy_up.mov)

>[!TIP]
>Registering and deploying machine learning models can take some time. 
>Once it's complete you can confirm the status with `rake stretchy:status`
>
> If you'd like to explore other rake tasks available run `rake -T | grep stretchy`


## Create a Source
We create a simple source that pulls a git repository and allows us to index it into `RepoFile`. 

*app/models/sources/git.rb*
```ruby
require 'open3'

module Sources
  class Git

    attr_reader :repo_url, :repo_name, :path
    attr_accessor :errors

    def initialize(repo_url, path: '/tmp')
      @repo_url = repo_url
      @repo_name = extract_repo_name(repo_url)
      @path = path
    end

    # Perform the git clone and ingest
    def perform(&block)
      clone unless File.directory?("#{path}/#{repo_name}")
      ingest(repo_url, &block)
    end

    # Clone the repo to path 
    def clone
      clone_cmd = "git clone #{repo_url} #{path}/#{repo_name}"
      Open3.popen2e(clone_cmd) do |stdin, stdout_err, wait_thr|
        while line = stdout_err.gets
          Rails.logger.debug line
        end
        exit_status = wait_thr.value
        unless exit_status.success?
          raise "FAILED to clone #{repo_url}"
        end
      end
    end


    # Remove the repo from the path
    def remove
      FileUtils.rm_rf("#{path}/#{repo_name}")
    end

    # Recursively crawl each file in the repo and yield the file to the block
    def ingest(repo_url, &block)
      @errors = []
      Dir.glob("#{path}/#{repo_name}/**/*").each do |file|
        if File.file?(file)
          begin
            yield file, self if block_given?
          rescue => e
            errors << [file, e]
          end
        end
      end
      
      return true
    end

    def errors?
      errors.any?
    end

    private

    def extract_repo_name(url)
      url.split('/').last.gsub('.git', '')
    end

  end
end

```

## Ingest Data

Start Rails console with `rails console` and run the following code.

This will checkout the repo and bulk index the file contents into `RepoFile`, automatically using the `TextEmbeddingPipeline` to create embeddings during ingest. 

```ruby
source = Sources::Git.new('https://github.com/theablefew/stretchy.git')

repo_files = source.perform do |file, instance|
	next unless ['.md', '.rb'].include?(File.extname(file))
	
	RepoFile.new(
		content: File.read(file),
		file_name: File.basename(file),
	)
end.compact

RepoFile.bulk_in_batches(repo_files, size: 100) do |batch|
	batch.map! { |record | record.to_bulk }
end
```


> [!TIP|label:Test it out]
> 
> We can now perform semantic searches using `neural` search. 
> 
> ```ruby
> RepoFile.neural(
>   embeddings: "How do I perform a percentile rank aggregation?",
>   model_id: TextEmbeddingModel.model_id,
>   k: 2
> )
> ```
> This is how our `Expert` will gather relevant context to pass to `GPT` LLM. 

## Interact

```ruby
expert = Expert.new
expert.ask("How can I perform a percentile ranks aggregation?")
```

We’ve asked how to perform a percentile ranks aggregation and provided our `Expert` relevant documentation as context with a `neural` search. 

> [!INFO|label:LLM Response]
>  You can perform a percentile ranks aggregation in Stretchy by using the `percentile_ranks` method. Here is an example to calculate the percentile ranks for values `[1, 2, 3]` on the field `'field_name'`:
> 
> ```ruby
> Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]})
> ```
>
>  This method will calculate the percentile ranks for the specified values on the specified field. 


### Conclusion

By following this guide, you've created a powerful expert system capable of providing informed responses to complex questions. This integration not only demonstrates the potential of combining semantic search with generative AI but also provides a solid foundation for further exploration and development.