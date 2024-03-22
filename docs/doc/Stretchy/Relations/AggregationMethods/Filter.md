# Stretchy::Relations::AggregationMethods::Filter [](#module-Stretchy::Relations::AggregationMethods::Filter) [](#top)

    

# Public Instance Methods

      
## filter(name, options = {}, *aggs) [](#method-i-filter)
         
Perform a filter aggregation.

This method is used to perform a filter_agg aggregation, which allows you to filter the data that an aggregation operates on. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:filter:` The Hash representing the filter to use for the filter_agg aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified filter_agg aggregation.

---

### Examples

#### Filter_agg aggregation

```ruby
  Model.filter(:my_agg, {filter: {...}})
  Model.filter(:my_agg, {filter: {...}}, aggs: {...})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).filter(:my_agg, {filter: {...}})
  results.aggregations.my_agg
```  
        
---

