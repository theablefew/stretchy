# Stretchy::Attributes::Type::Range::FloatRange [](#class-Stretchy::Attributes::Type::Range::FloatRange) [](#top)
The DoubleRange attribute type

This class is used to define a double_range attribute for a model. It provides support for the Elasticsearch range data type, which is a type of data type that can hold range of double values.

### Parameters

- `type:` `:double_range`.
- `options:` The Hash of options for the attribute.
   - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. This allows it to be used later for sorting, aggregations, or scripting. Defaults to true.
   - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
   - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
   - `:coerce:` The Boolean indicating if the field should automatically coerce the values to the data type. Defaults to true.

---

### Examples

#### Define a double_range attribute

```ruby
  class MyModel < StretchyModel
    attribute :weight_range, :double_range
  end
```
    

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

