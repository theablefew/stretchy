# RAG Agent

This example answers questions about help center articles with an ML Commons [flow agent](https://docs.opensearch.org/latest/ml-commons-plugin/agents-tools/agents/flow/). The agent uses `VectorDBTool` to find relevant articles, then `MLModelTool` to answer from them with an LLM.

It follows the setup in [Neural Search with LLM](examples/neural_search_with_llm) for the OpenSearch and OpenAI credentials.

>[!NOTE|label:Requirements]
> - OpenSearch 2.13 or later, with the ML Commons plugin
> - `opensearch-ruby` 4 (`bundle add opensearch-ruby --version ">= 4.0.0.pre.beta.5"`)

## Models

*app/machine_learning/embeddings.rb*

```ruby
class Embeddings < Stretchy::MachineLearning::ModelGroup
  description 'Embedding models for help center search'
  access_mode 'public'
end
```

*app/machine_learning/text_embedding_model.rb*

```ruby
class TextEmbeddingModel < Stretchy::MachineLearning::Model
  model :sentence_transformers_minilm_12
  version '1.0.1'
  model_format 'TORCH_SCRIPT'
  model_group :embeddings
end
```

*app/machine_learning/connectors/chat_connector.rb*

`MLModelTool` sends its prompt as `${parameters.prompt}`, so the connector puts it into the chat messages. See [connector blueprints](https://docs.opensearch.org/latest/ml-commons-plugin/remote-models/blueprints/).

```ruby
module Connectors
  class ChatConnector < Stretchy::MachineLearning::Connector
    description 'OpenAI chat completions'
    version 1
    protocol 'http'
    credentials Rails.application.credentials.dig(:openai)
    parameters endpoint: 'api.openai.com', model: 'gpt-4o-mini'

    actions action_type: 'predict',
            method: 'POST',
            url: 'https://${parameters.endpoint}/v1/chat/completions',
            headers: { 'Authorization': 'Bearer ${credential.openAI_key}' },
            request_body: '{"model":"${parameters.model}","messages":[{"role":"user","content":"${parameters.prompt}"}]}'
  end
end
```

*app/machine_learning/gpt.rb*

```ruby
class GPT < Stretchy::MachineLearning::Model
  model_name 'gpt'
  function_name :remote
  connector 'Connectors::ChatConnector'
end
```

## Index

*app/pipelines/ingest/article_embedding_pipeline.rb*

```ruby
class ArticleEmbeddingPipeline < Stretchy::IngestPipeline
  description 'Embeds article bodies'
  processor :text_embedding, model: :text_embedding_model, field_map: { body: :body_embedding }
end
```

*app/models/article.rb*

```ruby
class Article < StretchyModel
  attribute :title, :text
  attribute :body, :text
  attribute :body_embedding, :knn_vector, dimension: 384

  default_pipeline :article_embedding_pipeline

  index_settings knn: true
end
```

## Agent

*app/machine_learning/agents/help_center_agent.rb*

```ruby
class HelpCenterAgent < Stretchy::MachineLearning::Agent
  agent_type :flow
  description 'Answers questions from help center articles'

  tool :vector_db,
       model: :text_embedding_model,
       index: Article,
       embedding_field: 'body_embedding',
       source_field: ['title', 'body'],
       input: '${parameters.question}'

  tool :ml_model,
       name: 'answer',
       model: :gpt,
       prompt: <<~PROMPT
         Answer the question using only these articles. Say so if they do not contain the answer.

         Articles: ${parameters.VectorDBTool.output}

         Question: ${parameters.question}
       PROMPT
end
```

`model:` and `index:` resolve when the agent registers, so register it after the models deploy and the index exists.

## Deploy

```sh
rails runner 'Embeddings.register!'
rake stretchy:up
```

`stretchy:up` creates connectors, registers and deploys models, creates agents, then creates pipelines and indexes. Ingest some articles, then ask a question:

```ruby
Article.create(title: 'Resetting your password', body: 'Use the "Forgot password" link on the sign in page...')
Article.refresh_index!

HelpCenterAgent.execute(question: 'How do I reset my password?')
# => [{ "output" => [{ "name" => "answer", "result" => "Use the \"Forgot password\" link on the sign in page." }] }]
```

`rake stretchy:down` deletes the agent before it undeploys the models.
