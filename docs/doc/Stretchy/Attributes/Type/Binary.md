# Stretchy::Attributes::Type::Binary [](#class-Stretchy::Attributes::Type::Binary) [](#top)
The Binary attribute type

This class is used to define a binary attribute for a model. It provides support for the Elasticsearch binary data type, which is a type of data type that can hold binary data.

### Parameters

- `type:` `:binary`.
- `options:` The Hash of options for the attribute.
   - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. This allows it to be used later for sorting, aggregations, or scripting. Defaults to false.
   - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.

---

### Examples

#### Define a binary attribute

```ruby
  class MyModel < StretchyModel
    attribute :data, :binary, doc_values: true, store: true
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Class Methods

      
## new(**args) [](#method-c-new)
         
  
        
---


# Public Instance Methods

      
## mappings(name) [](#method-i-mappings)
         
  
        
---


## type() [](#method-i-type)
         
  
        
---

