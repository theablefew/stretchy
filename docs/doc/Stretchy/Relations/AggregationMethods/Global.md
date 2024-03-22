# Stretchy::Relations::AggregationMethods::Global [](#module-Stretchy::Relations::AggregationMethods::Global) [](#top)

    

# Public Instance Methods

      
## global(name, options = {}, *aggs) [](#method-i-global)
         
Perform a global aggregation.

This method is used to perform a global aggregation, which allows you to count all documents matching a query, regardless of the search scope. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified global aggregation.

---

### Examples

#### Global aggregation

```ruby
  Model.global(:my_agg)
  Model.global(:my_agg, {}, aggs: {...})
```  
        
---

