# Stretchy::MachineLearning::Model [](#class-Stretchy::MachineLearning::Model) [](#top)

    
## Constants
| Name | Description |
| ---- | ----------- |
| **PRETRAINED_MODELS[](#PRETRAINED_MODELS)** | Not Documented |

### Attributes

#### group_id[RW] [](#attribute-c-group_id)
 
 

#### model[RW] [](#attribute-c-model)
 
 

#### connector[RW] [](#attribute-i-connector)
 
 

#### connector_id[RW] [](#attribute-i-connector_id)
 
 

#### deploy_id[R] [](#attribute-i-deploy_id)
 
 

#### description[RW] [](#attribute-i-description)
 
 

#### enabled[RW] [](#attribute-i-enabled)
 
 

#### function_name[RW] [](#attribute-i-function_name)
 
 

#### group_id[RW] [](#attribute-i-group_id)
 
 

#### model[RW] [](#attribute-i-model)
 
 

#### model_config[RW] [](#attribute-i-model_config)
 
 

#### model_content_hash_value[RW] [](#attribute-i-model_content_hash_value)
 
 

#### model_format[RW] [](#attribute-i-model_format)
 
 

#### model_id[R] [](#attribute-i-model_id)
 
 

#### task_id[R] [](#attribute-i-task_id)
 
 

#### url[RW] [](#attribute-i-url)
 
 

#### version[RW] [](#attribute-i-version)
 
 

---


# Public Class Methods

      
## all() [](#method-c-all)
         
  
        
---


## ml_on_all_nodes!() [](#method-c-ml_on_all_nodes-21)
         
  
        
---


## ml_on_ml_nodes!() [](#method-c-ml_on_ml_nodes-21)
         
  
        
---


## model_lookup(model) [](#method-c-model_lookup)
         
  
        
---


## new(args = {}) [](#method-c-new)
         
  
        
---


# Public Instance Methods

      
## client() [](#method-i-client)
         
  
        
---


## delete() [](#method-i-delete)
         
  
        
---


## deploy() { |self| ... } [](#method-i-deploy)
         
  
        
---


## deployed?() [](#method-i-deployed-3F)
         
  
        
---


## enabled?() [](#method-i-enabled-3F)
         
  
        
---


## find() [](#method-i-find)
         
  
        
---


## register() { |self| ... } [](#method-i-register)
         
  
        
---


## registered?() [](#method-i-registered-3F)
         
  
        
---


## status() [](#method-i-status)
         
  
        
---


## to_hash() [](#method-i-to_hash)
         
  
        
---


## undeploy() { |self| ... } [](#method-i-undeploy)
         
  
        
---


## wait_until_complete(max_attempts: 20, sleep_time: 4) { || ... } [](#method-i-wait_until_complete)
         
  
        
---

