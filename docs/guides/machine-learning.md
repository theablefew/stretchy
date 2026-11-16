# Machine Learning
>[!NOTE|style:flat|label:OpenSearch only]
> Models, model groups, connectors and agents use the [ML Commons plugin](https://docs.opensearch.org/latest/ml-commons-plugin/) through the `client.ml` API of `opensearch-ruby` 4. They are not available on Elasticsearch.

## Models
Machine Learning models follow a specific convention for storing model definitions. This helps us keep our code organized and easy to navigate.

- *app/machine_learning/models/example_machine_learning_model.rb*

A `MachineLearningModel` consists of the following components:

```ruby
class SparseEncodingModel < Stretchy::MachineLearning::Model
  model :neural_sparse_encoding
  version '1.0.1'
  model_format 'TORCH_SCRIPT'
  description 'Creates sparse embedding for onboarding docs'
  model_group :embeddings
end
```
- `model:` This is the name of the model. It should match one of the pre-trained models available in your application. In this case, it's :neural_sparse_encoding.

  - `version:` This is the version of the model. It's important to specify this, as different versions of the same model may have different behaviors or requirements.

  - `model_format:` This is the format of the model. It tells Stretchy how to interpret the model file. In this case, it's 'TORCH_SCRIPT', which means the model is a TorchScript file. TorchScript is a way to serialize PyTorch models.

  - `description:` This is a brief description of what the model does. It's a good practice to provide a meaningful description so that others can understand the purpose of your model at a glance. In this case, the description is 'Creates sparse embedding for onboarding docs'.

  - `model_group:` The [model group](#model-groups) the model registers into, given as the group's class name.

## Model Groups
A [model group](https://docs.opensearch.org/latest/ml-commons-plugin/model-access-control/) collects versions of a model and controls who can use them. Register the group before the models that belong to it.

```ruby
class Embeddings < Stretchy::MachineLearning::ModelGroup
  description 'Sentence embedding models'
  access_mode 'public'
end

Embeddings.register!
Embeddings.exists?  # => true
Embeddings.delete!
```

The group name defaults to the underscored class name. Set another with `remote_name 'shared_embeddings'`.



## Managing Models

>[!TIP|label:Machine Learning Settings]
> When running development or single-node clusters you may need to adjust your cluster settings to allow Machine Learning models to run on all nodes instead of dedicated machine learning nodes.
> Add `Stretchy::MachineLearning::Model.ml_on_all_nodes!` to your *config/environments/development.rb* file to enable machine learning on all nodes. 

### register
Registers the machine learning model. Registering no longer deploys the model; call [deploy](#deploy) once registration completes.

```ruby
MyMachineLearningModel.register
```
The `register` operation is asynchronous and can take some time to complete. To wait until the operation is complete use the helper method `wait_until_complete` in combination with the `registered?` method:
```ruby
MyMachineLearningModel.register do |model|
  model.wait_until_complete do
    model.registered?
  end
end
```

### registered?
Checks the model status and returns true if `model_id` is present and `state` is `COMPLETED`

```ruby
MyMachineLearningModel.registered?
```

### status
Returns the status of the model registration

```ruby
MyMachineLearningModel.status
```

### deploy
Deploys the model making it available for use. Requires the model to be registered. 

```ruby
MyMachineLearningModel.deploy
```

The `deploy` operation is asynchronous and can take some time to complete. Use the `wait_until_complete` method in combination with `deployed?` to wait until the model is deployed. 

```ruby
MyMachineLearningModel.deploy do |model|
  model.wait_until_complete(sleep_time: 5) do
    model.deployed?
  end
end
```

### undeploy
Undeploys the model. 

```ruby
MyMachineLearningModel.undeploy
```

### deployed?
Gets the model and checks if `model_state` is `DEPLOYED`. The state is fetched on every call.

```ruby
MyMachineLearningModel.deployed?
```

### delete
Deletes the model. The model must be undeployed before it can be deleted. 

```ruby
MyMachineLearningModel.delete
```

### wait_until_complete
A helper to provide wait for completion of async tasks. Accepts `max_attempts` and `sleep_time`. 

```ruby
MyMLModel.register do |model|
  model.wait_until_complete(max_attempts: 20, sleep_time: 4) do
    # finish waiting if last statement is true
    model.registered?
  end
end
```

### all
Returns all registered models.

```ruby
MyMLModel.all
```

## Agents
An [agent](https://docs.opensearch.org/latest/ml-commons-plugin/agents-tools/index/) runs a set of tools, usually with an LLM, inside the cluster. Declare one with an agent type, an LLM, memory and tools.

```ruby
class SupportAgent < Stretchy::MachineLearning::Agent
  agent_type :conversational
  description 'Answers support questions from the help center'
  llm :claude_model, parameters: { max_iteration: 5 }
  memory :conversation_index
  tool :vector_db, model: :embedding_model, index: Article, embedding_field: 'body_embedding', source_field: ['body']
  tool :ml_model, name: 'answer', model: :claude_model, prompt: '${parameters.question}'
end
```

- `agent_type` One of `:flow`, `:conversational_flow`, `:conversational` or `:plan_execute_and_reflect`. See [agent types](https://docs.opensearch.org/latest/ml-commons-plugin/agents-tools/agents/index/).
- `llm` The model the agent reasons with, as a model class name or a model id, with optional `parameters`.
- `memory` The memory type, such as `:conversation_index`.
- `tool` Adds a [tool](https://docs.opensearch.org/latest/ml-commons-plugin/agents-tools/tools/index/). The tool type is camelized, so `:search_index` becomes `SearchIndexTool`; `:ml_model`, `:vector_db`, `:ppl` and `:rag` map to `MLModelTool`, `VectorDBTool`, `PPLTool` and `RAGTool`. `model:` resolves to the model id and `index:` to the model's index name when the agent registers. `name:` and `description:` describe the tool, and every other option is sent as a tool parameter.

### Managing agents

```ruby
SupportAgent.register!
SupportAgent.execute(question: 'How do I reset my password?')
# => [{ "output" => [{ "name" => "answer", "result" => "..." }] }]
SupportAgent.exists?
SupportAgent.delete!
```

`execute` raises `Stretchy::MachineLearning::Errors::AgentNotRegisteredError` when the agent has not been registered.

## Agentic Search
[Agentic search](https://docs.opensearch.org/latest/vector-search/ai-search/agentic-search/index/) turns a natural language question into a query. It needs an agent with the `QueryPlanningTool` and a search pipeline with the `agentic_query_translator` processor that points at it.

```ruby
class ProductSearchAgent < Stretchy::MachineLearning::Agent
  agent_type :flow
  tool :query_planning, model: :claude_model
end

class AgenticPipeline < Stretchy::SearchPipeline
  request_processor :agentic_query_translator, agent: :product_search_agent
end

Product.search_pipeline(:agentic_pipeline).agentic('red shoes under $50', query_fields: [:name, :description])
```

`agentic` must be the only query in the request; a later call replaces an earlier one. Pass `memory_id:` to continue a conversation with a conversational agent.

## Rake tasks

| Task | Description |
| --- | --- |
| `rake stretchy:up` | Creates connectors, registers and deploys models, creates agents, pipelines and indexes |
| `rake stretchy:down` | Deletes agents, undeploys and deletes models, then deletes connectors, pipelines and indexes |
| `rake stretchy:ml:agent:create` | Registers agents. `AGENT=SupportAgent` limits it to one |
| `rake stretchy:ml:agent:delete` | Deletes agents |
| `rake stretchy:ml:agent:status` | Shows which agents are registered |

## Pre-trained models
OpenSearch provides a variety of pre-trained models for different tasks:

### Neural Sparse Models
- `:neural_sparse_encoding` - 'amazon/neural-sparse/opensearch-neural-sparse-encoding-v1'
- `:neural_sparse_encoding_doc` - 'amazon/neural-sparse/opensearch-neural-sparse-encoding-doc-v1'
- `:neural_sparse_tokenizer` - 'amazon/neural-sparse/opensearch-neural-sparse-tokenizer-v1'

### Cross Encoder Models
- `:cross_encoder_minilm_6` - 'huggingface/cross-encoders/ms-marco-MiniLM-L-6-v2'
- `:cross_encoder_minilm_12` - 'huggingface/cross-encoders/ms-marco-MiniLM-L-12-v2'

### Sentence Transformer Models
- `:sentence_transformers_roberta_all` - 'huggingface/sentence-transformers/all-distilroberta-v1'
- `:sentence_transformers_msmarco` - 'huggingface/sentence-transformers/msmarco-distilroberta-base-v2'
- `:sentence_transformers_minilm_6` - 'huggingface/sentence-transformers/all-MiniLM-L6-v2'
- `:sentence_transformers_minilm_12` - 'huggingface/sentence-transformers/all-MiniLM-L12-v2'
- `:sentence_transformers_mpnet` - 'huggingface/sentence-transformers/all-mpnet-base-v'
- `:sentence_transformers_multi_qa_minilm_6` - 'huggingface/sentence-transformers/multi-qa-MiniLM-L6-cos-v1'
- `:sentence_transformers_multi_qa_mpnet` - 'huggingface/sentence-transformers/multi-qa-mpnet-base-dot-v1'
- `:sentence_transformers_paraphrase_minilm_3` - 'huggingface/sentence-transformers/paraphrase-MiniLM-L3-v2'
- `:sentence_transformers_paraphrase_multilingual_minilm_12` - 'huggingface/sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2'
- `:sentence_transformers_paraphrase_mpnet` - 'huggingface/sentence-transformers/paraphrase-mpnet-base-v2'
- `:sentence_transformers_multilingual_distiluse_cased` - 'huggingface/sentence-transformers/distiluse-base-multilingual-cased-v1'

## Custom Models

Refer to the OpenSearch documentation on [deploying custom local models](https://opensearch.org/docs/latest/ml-commons-plugin/custom-local-models/)