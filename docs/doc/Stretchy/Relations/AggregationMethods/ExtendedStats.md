# Stretchy::Relations::AggregationMethods::ExtendedStats [](#module-Stretchy::Relations::AggregationMethods::ExtendedStats) [](#top)

    

# Public Instance Methods

      
## extended_stats(name, options = {}, *aggs) [](#method-i-extended_stats)
         
Perform an extended_stats aggregation.

This method is used to perform an extended_stats aggregation, which allows you to compute several statistical measures from your data. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the extended_stats aggregation.
    - `:sigma:` The Float representing the sigma for the extended_stats aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified extended_stats aggregation.

---

### Examples

#### Extended_stats aggregation

```ruby
  Model.extended_stats(:my_agg, {field: 'field_name', sigma: 1.0})
  Model.extended_stats(:my_agg, {field: 'field_name', sigma: 1.0}, aggs: {...})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).extended_stats(:my_agg, {field: 'field_name', sigma: 1.0})
  results.aggregations.my_agg
```  
        
---

