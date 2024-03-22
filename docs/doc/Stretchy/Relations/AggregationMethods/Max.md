# Stretchy::Relations::AggregationMethods::Max [](#module-Stretchy::Relations::AggregationMethods::Max) [](#top)

    

# Public Instance Methods

      
## max(name, options = {}, *aggs) [](#method-i-max)
         
Perform a max aggregation.

This method is used to perform a max aggregation, which allows you to find the maximum value of a field in the data set. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the max aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified max aggregation.

---

### Examples

#### Max aggregation

```ruby
  Model.max(:my_agg, {field: 'field_name'})
  Model.max(:my_agg, {field: 'field_name'}, aggs: {...})
```  
        
---

