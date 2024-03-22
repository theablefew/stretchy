# Stretchy::Attributes::Type::Range::IpRange [](#class-Stretchy::Attributes::Type::Range::IpRange) [](#top)
The IpRange attribute type

This class is used to define an ip_range attribute for a model. It provides support for the Elasticsearch range data type, which is a type of data type that can hold range of IP values.

### Parameters

- `type:` `:ip_range`.
- `options:` The Hash of options for the attribute.
   - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. This allows it to be used later for sorting, aggregations, or scripting. Defaults to true.
   - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
   - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
   - `:coerce:` The Boolean indicating if the field should automatically coerce the values to the data type. Defaults to true.

---

### Examples

#### Define an ip_range attribute

```ruby
  class MyModel < StretchyModel
    attribute :ip_range, :ip_range
  end
```
    

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

