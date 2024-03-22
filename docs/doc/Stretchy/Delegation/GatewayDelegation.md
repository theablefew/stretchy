# Stretchy::Delegation::GatewayDelegation [](#module-Stretchy::Delegation::GatewayDelegation) [](#top)

    

# Public Instance Methods

      
## gateway(&block) [](#method-i-gateway)
         
This method is used to access the underlying `Stretchy::Repository` for the model. It creates the repository if it doesn't exist, and reuses it if it does.

### Parameters

- `&block:` (optional) A block that is evaluated in the context of the repository. This can be used to perform operations on the repository.

### Returns

- (Stretchy::Repository) - The repository for the model.

### Behavior

- If the repository doesn't exist or if the client of the existing repository is not the current client from the Stretchy configuration, 
  it creates a new repository with the current `client`, `index_name`, `class`, `mapping`, and `settings`.
- If a block is given, it is evaluated in the context of the repository.
- It always returns the repository.

### Example

```ruby
class MyModel < Stretchy::Record
  gateway do
    # Perform operations on the repository
  end
end
```  
        
---


## index_name(name=nil, &block) [](#method-i-index_name)
         
This method is used to set or retrieve the index name for the Elasticsearch index.

### Parameters

- `name:` (String, nil) - The name to set for the index. If nil, the method will act as a getter.
- `&block:` A block that returns the index name when called.

### Returns

- (String) - The index name.

### Behavior

- If a name or block is provided, it sets the index name to the provided name or block.
- If no argument is provided, it retrieves the index name. 
- If the index name is callable (e.g., a Proc), it calls the block.
- If the index name is not set, it defaults to the parameterized and underscored collection name of the base class model.

### Example

In this example, the index name for instances of `MyModel` will be "my_custom_index" instead of "my_models".

```ruby
class MyModel < Stretchy::Record
  index_name "my_custom_index"
end
```  
        
---


## index_settings(settings={}) [](#method-i-index_settings)
         
This method is used to set or retrieve the settings for the Elasticsearch index.

### Parameters

- `settings:` (Hash) - The settings to set for the index. If empty, the method will act as a getter.

### Returns

- (Hash) - The index settings.

### Behavior

- If settings are provided, it sets the index settings to the provided settings.
- If no argument is provided, it retrieves the index settings. 
- If the `default_pipeline` is set, it merges it into the index settings.

### Example

```ruby
class MyModel < Stretchy::Record
  index_settings number_of_shards: 5, number_of_replicas: 1
end
```
In this example, the index settings for instances of `MyModel` will have 5 shards and 1 replica.  
        
---


## reload_gateway_configuration!() [](#method-i-reload_gateway_configuration-21)
         
  
        
---

