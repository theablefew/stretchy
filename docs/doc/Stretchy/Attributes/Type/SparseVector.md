# Stretchy::Attributes::Type::SparseVector [](#class-Stretchy::Attributes::Type::SparseVector) [](#top)
The SparseVector attribute type

This class is used to define a sparse_vector attribute for a model. It provides support for the Elasticsearch sparse_vector data type, which is a type of data type that can hold sparse vectors of float values.

### Parameters

- `type:` `:sparse_vector`.
- `options:` The Hash of options for the attribute. This type does not have any specific options.

---

### Examples

#### Define a sparse_vector attribute

```ruby
  class MyModel < StretchyModel
    attribute :ml, :sparse_vector
  end
```
    

# Public Instance Methods

      
## mappings(name) [](#method-i-mappings)
         
  
        
---


## type() [](#method-i-type)
         
  
        
---

