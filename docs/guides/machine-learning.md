# Machine Learning
>[!NOTE|style:flat|label:OpenSearch Compatability]
> OpenSearch and Elasticsearch diverge in how they handle machine learning APIs. These features are in active development and subject to change.
>
> This guide largely covers OpenSearch Machine Learning unless otherwise stated. 

>[!WARNING|label:Machine Learning on Elasticsearch]
> Elasticsearch requires a license to enable ML capabilities

## Models
Machine Learning models follow a specific convention for storing model definitions. This helps us keep our code organized and easy to navigate.

- *app/machine_learning/models/example_machine_learning_model.rb*

A `MachineLearningModel` consists of the following components:

```ruby
class SparseEncodingModel < Stretchy::MachineLearning::Model
  model: :neural_sparse_encoding,
          version: '1.0.1',
          model_format: 'TORCH_SCRIPT',
          description: 'Creates sparse embedding for onboarding docs'
end
```
- `model:` This is the name of the model. It should match one of the pre-trained models available in your application. In this case, it's :neural_sparse_encoding.

  - `version:` This is the version of the model. It's important to specify this, as different versions of the same model may have different behaviors or requirements.

  - `model_format:` This is the format of the model. It tells Stretchy how to interpret the model file. In this case, it's 'TORCH_SCRIPT', which means the model is a TorchScript file. TorchScript is a way to serialize PyTorch models.

  - `description:` This is a brief description of what the model does. It's a good practice to provide a meaningful description so that others can understand the purpose of your model at a glance. In this case, the description is 'Creates sparse embedding for onboarding docs'.



## Managing Models

>[!TIP|label:Machine Learning Settings]
> When running development or single-node clusters you may need to adjust your cluster settings to allow Machine Learning models to run on all nodes instead of dedicated machine learning nodes.
> Add `Stretchy::MachineLearning::Model.ml_on_all_nodes!` to your *config/environments/development.rb* file to enable machine learning on all nodes. 

### register
Registers the machine learning model. 

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
Gets the model and checks if `model_state` is `DEPLOYED`

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