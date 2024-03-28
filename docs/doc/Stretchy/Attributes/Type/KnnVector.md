# Stretchy::Attributes::Type::KnnVector [](#class-Stretchy::Attributes::Type::KnnVector) [](#top)
The KnnVector attribute type.

This class is used to define a `knn_vector` attribute for a model. 
It provides support for the Elasticsearch `knn_vector` data type, 
which is a type of data type that can hold vectors of float values.

### Parameters

The `knn_vector` data type supports the following options:
- `dimension`: The number of dimensions in the vector.
- `method`: The method used for nearest neighbor search. This is a hash that can include the following keys:
  - `name`: The name of the method.
  - `space_type`: The type of space used for the method.
  - `engine`: The engine used for the method.
  - `parameters`: Any additional parameters for the method.

---

### Examples

#### Define a `knn_vector` attribute

```ruby
  class MyModel < StretchyModel
    attribute :my_vector, :knn_vector
  end
```

#### Define a `knn_vector` attribute with options

```ruby
  class MyModel < StretchyModel
    attribute :my_vector, :knn_vector, dimension: 3, method: { name: "hnsw", space_type: "cosinesimil", engine: "nmslib", parameters: { ef_construction: 200 } }
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

