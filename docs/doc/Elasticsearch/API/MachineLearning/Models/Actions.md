# Elasticsearch::API::MachineLearning::Models::Actions [](#module-Elasticsearch::API::MachineLearning::Models::Actions) [](#top)

    

# Public Instance Methods

      
## delete_model(arguments = {}) [](#method-i-delete_model)
         
Returns a model.

@option arguments [String] :id The model id
@option arguments [Hash] :headers Custom HTTP headers

Example
delete_model(id: 109sdj0asl092)

DELETE /_plugins/_ml/models/<model_id>  
        
---


## deploy(arguments = {}) [](#method-i-deploy)
         
Register a model.

@option arguments [String] :id The model id
@option arguments [Hash] :body The deploy options

POST /_plugins/_ml/models/<model_id>/_deploy  
        
---


## get_model(arguments = {}) [](#method-i-get_model)
         
Returns a model.

@option arguments [String] :id The model id

Example
get_model(id: 109sdj0asl092)

Example
# Get all models
get_model

GET /_plugins/_ml/models/<model_id>  
        
---


## get_status(arguments = {}) [](#method-i-get_status)
         
Register a model.

@option arguments [String] :id The model id
@option arguments [Hash] :body The deploy options

GET /_plugins/_ml/tasks/<task_id>  
        
---


## register(arguments = {}) [](#method-i-register)
         
Register a model.

@option arguments [Hash] :body The model definition **Required**
@option arguments [Boolean] :deploy Whether to deploy the model after registering it. The deploy operation is performed by calling the [Deploy Model API](https://opensearch.org/docs/latest/ml-commons-plugin/api/model-apis/deploy-model/). Default is `false`

Example
client.machine_learing_model.register(body: {
      "name": "huggingface/sentence-transformers/msmarco-distilbert-base-tas-b",
      "version": "1.0.1",
      "model_group_id": "Z1eQf4oB5Vm0Tdw8EIP2",
      "model_format": "TORCH_SCRIPT"
    },
    deploy: true 

POST /_plugins/_ml/models/_register  
        
---


## undeploy(arguments = {}) [](#method-i-undeploy)
         
Register a model.

@option arguments [String] :id The model id
@option arguments [Hash] :body The deploy options

POST /_plugins/_ml/models/<model_id>/_undeploy  
        
---


## update_model(arguments = {}) [](#method-i-update_model)
         
Returns a model.

@option arguments [String] :id The model id
@option arguments [Hash] :body The request fields

Example
update_model(id: 109sdj0asl092, "rate_limiter": {
   "limit": "4",
   "unit": "MINUTES"
 }
)

PUT /_plugins/_ml/models/<model_id>  
        
---

