# Stretchy::Model::Refreshable [](#module-Stretchy::Model::Refreshable) [](#top)
Adds callbacks to the model to refresh the index after save or destroy.

```ruby
included do
  after_save :refresh_index
  after_destroy :refresh_index
end
```
    

# Public Instance Methods

      
## refresh_index() [](#method-i-refresh_index)
         
  
        
---

