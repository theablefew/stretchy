# Elasticsearch::API::MachineLearning::Models::Actions::ParamsRegistry [](#module-Elasticsearch::API::MachineLearning::Models::Actions::ParamsRegistry) [](#top)

    
## Constants
| Name | Description |
| ---- | ----------- |
| **PARAMS[](#PARAMS)** | <p>A Mapping of all the actions to their list of valid params.</p>

<p>@since 6.1.1</p> |

# Public Instance Methods

      
## get(action) [](#method-i-get)
         
Get the list of valid params for a given action.

@example Get the list of valid params.
  ParamsRegistry.get(:benchmark)

@param [ Symbol ] action The action.

@return [ Array<Symbol> ] The list of valid params for the action.

@since 6.1.1  
        
---


## register(action, valid_params) [](#method-i-register)
         
Register an action with its list of valid params.

@example Register the action.
  ParamsRegistry.register(:benchmark, [ :verbose ])

@param [ Symbol ] action The action to register.
@param [ Array[Symbol] ] valid_params The list of valid params.

@since 6.1.1  
        
---

