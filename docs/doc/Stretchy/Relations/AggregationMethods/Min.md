# Stretchy::Relations::AggregationMethods::Min [](#module-Stretchy::Relations::AggregationMethods::Min) [](#top)

    

# Public Instance Methods

      
## min(name, options = {}, *aggs) [](#method-i-min)
         
Perform a min aggregation.

This method is used to perform a min aggregation, which allows you to find the minimum value of a field in the data set. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the min aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified min aggregation.

---

### Examples

#### Min aggregation

```ruby
  Model.min(:my_agg, {field: 'field_name'})
  Model.min(:my_agg, {field: 'field_name'}, aggs: {...})
```  
        
---

