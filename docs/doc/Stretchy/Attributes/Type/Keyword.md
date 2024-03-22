# Stretchy::Attributes::Type::Keyword [](#class-Stretchy::Attributes::Type::Keyword) [](#top)
The Join attribute type

This class is used to define a join attribute for a model. It provides support for the Elasticsearch join data type, which is a type of data type that can hold parent/child relationships within documents of the same index.

### Parameters

- `type:` `:join`.
- `options:` The Hash of options for the attribute.
   - `:relations:` The Hash defining a set of possible relations within the documents, each relation being a parent name and a child name.

---

### Examples

#### Define a join attribute

```ruby
  class MyModel < StretchyModel
    attribute :relation, :join, relations: { question: :answer }
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

