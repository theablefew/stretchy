# Stretchy::Attributes::Type::Array [](#class-Stretchy::Attributes::Type::Array) [](#top)
The Array attribute type

This class is used to define an array attribute for a model. It provides support for the Elasticsearch array data type, which is a type of data type that can hold multiple values.

### Parameters

- `type:` `:array`.
- `options:` The Hash of options for the attribute.
   - `:data_type:` The Symbol representing the data type for the array. Defaults to `:text`.
   - `:fields:` The Boolean indicating if fields should be included in the mapping. Defaults to `true`.

---

### Examples

#### Define an array attribute

```ruby
  class MyModel < StretchyModel
    attribute :tags, :array, data_type: :text
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## mappings(name) [](#method-i-mappings)
         
  
        
---


## type() [](#method-i-type)
         
  
        
---


## type_for_database() [](#method-i-type_for_database)
         
  
        
---

