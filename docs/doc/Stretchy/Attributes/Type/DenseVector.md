# Stretchy::Attributes::Type::DenseVector [](#class-Stretchy::Attributes::Type::DenseVector) [](#top)
The DenseVector attribute type

This class is used to define a dense vector attribute for a model. It provides support for the Elasticsearch dense vector data type, which is a type of data type that can hold dense vectors of float values.

### Parameters

- `type:` `:dense_vector`.
- `options:` The Hash of options for the attribute.
   - `:element_type:` The String data type used to encode vectors. Can be 'float' or 'byte'.
   - `:dims:` The Integer number of vector dimensions. Can’t exceed 4096.
   - `:index:` The Boolean indicating if you can search this field using the kNN search API (default: true).
   - `:similarity:` The String vector similarity metric to use in kNN search. Can be 'l2_norm', 'dot_product', 'cosine', or 'max_inner_product'.
   - `:index_options:` The Hash that configures the kNN indexing algorithm.

---

### Examples

#### Define a dense vector attribute

```ruby
  class MyModel < StretchyModel
    attribute :vector_embeddings, :dense_vector, element_type: 'float', dims: 3
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

