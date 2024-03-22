# Stretchy::Relations::AggregationMethods::Percentiles [](#module-Stretchy::Relations::AggregationMethods::Percentiles) [](#top)

    

# Public Instance Methods

      
## percentiles(name, options = {}, *aggs) [](#method-i-percentiles)
         
Perform a percentiles aggregation.

This method is used to perform a percentiles aggregation, which allows you to calculate the percentiles of a set of values. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the percentiles aggregation.
    - `:percents:` The Array of Floats representing the percentiles to calculate for the percentiles aggregation. Example: percents: [95, 99, 99.9]
    - `:keyed:` The Boolean that associates a unique string key with each bucket and returns the ranges as a hash rather than an array. Default is true.
    - `:tdigest:` The Hash representing the tdigest to use for the percentiles aggregation. Example: tdigest: {compression: 100, execution_hint: "high_accuracy"}
        - `:compression:` The Float representing the compression factor to use for the t-digest algorithm. A higher compression factor will yield more accurate percentiles, but will require more memory. The default value is 100.
        - `:execution_hint:` The String representing the execution_hint to use for the t-digest algorithm. Example: execution_hint: "auto"
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified percentiles aggregation.

---

### Examples

#### Percentiles aggregation

```ruby
  Model.percentiles(:my_agg, {field: 'field_name', percents: [1, 2, 3]})
  Model.percentiles(:my_agg, {field: 'field_name', percents: [1, 2, 3]}, aggs: {...})
```  
        
---

