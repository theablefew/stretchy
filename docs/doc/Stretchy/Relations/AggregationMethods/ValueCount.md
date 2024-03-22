# Stretchy::Relations::AggregationMethods::ValueCount [](#module-Stretchy::Relations::AggregationMethods::ValueCount) [](#top)

    

# Public Instance Methods

      
## value_count(name, options = {}, *aggs) [](#method-i-value_count)
         
Perform a value_count aggregation.

This method is used to perform a value_count aggregation, which allows you to compute the count of values for a specific field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the value_count aggregation.
    - `:script:` The Hash representing the script to use for the value_count aggregation. Example: script: {source: "doc['field_name'].value", lang: "painless"}
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified value_count aggregation.

---

### Examples

#### Value_count aggregation

```ruby
  Model.value_count(:my_agg, {field: 'field_name'})
  Model.value_count(:my_agg, {field: 'field_name'}, aggs: {...})
```  
        
---

