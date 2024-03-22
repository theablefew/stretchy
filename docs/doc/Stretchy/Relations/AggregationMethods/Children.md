# Stretchy::Relations::AggregationMethods::Children [](#module-Stretchy::Relations::AggregationMethods::Children) [](#top)

    

# Public Instance Methods

      
## children(name, options = {}, *aggs) [](#method-i-children)
         
Perform a children aggregation.

This method is used to aggregate on child documents of the parent documents that match the query. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:type:` The String representing the type of children to aggregate.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified children aggregation.

---

### Examples

#### Children aggregation

```ruby
  Model.children(:my_agg, {type: 'my_type'})
  Model.children(:my_agg, {type: 'my_type'}, aggs: {...})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).children(:my_agg, {type: 'my_type'})
  results.aggregations.my_agg
```  
        
---

