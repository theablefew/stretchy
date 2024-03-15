# Semantic Search with LLMs


# Text Embeddings

* OpenAI embeddings
* Elasticsearch Embeddings with Compatible Models
  * `all-MiniLM-L6-v2`

# Set up Elasticsearch

# Ingest Pipeline

_Set up ingest pipeline with inference model_


# Rails app

_Use simple stimulus app_

```
rails new semantic_search
```

```
cd semantic_search
```

```
bundle add stretchy-model
```


## Define Models
```ruby
class Repo < StretchyModel
	attribute :name, :string
	attribute :meta, :hash
	attribute :files, :nested
	has_many :files
end
```

```ruby
class File < StretchyModel
	attribute :name, :string
  attribute :path, :string
	attribute :content, :text
	attribute :file_embeddings, :dense_vector
	attribute :method_definitions, :array
	attribute :language, :string
end
```

## Controller
```ruby
def search
  query_text = params[:query_text] 
  # =>  "Please provide a patch to fix this error:\nNameError: uninitialized constant TestModel\n# ./spec/stretchy_model_spec.rb:29:in `block in <top (required)>'"

  response = File.where(content: query_text)
        .exists?(field: :file_embeddings)
        .knn(
          field: :file_embeddings,
          k: 1,
          num_candidates: 20,
          query_vector_builder: {
            text_embedding: {
                model_id: :sentence_transformers,
                model_text: query_text
            }
          },
          boost: 24
        )
        .fields(:content, :name, :path)


  negative_response = "Unable to find the answer to your question given the provided context."

  prompt = "Answer this question: #{query_text}\nUsing only the information from this Elastic Doc: #{response}\nIf the answer is not contained in the supplied doc reply '#{negative_response}' and nothing else"

  @answer = LLM.chat(prompt)
end
```

## Views

```slim

div[data-controller="search"]
  = simple_form :search do |f|
    = f.input :query_text
    = f.submit

#responses data-controller="response"

```
