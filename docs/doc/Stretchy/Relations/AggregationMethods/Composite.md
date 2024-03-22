# Stretchy::Relations::AggregationMethods::Composite [](#module-Stretchy::Relations::AggregationMethods::Composite) [](#top)

    

# Public Instance Methods

      
## composite(name, options = {}, *aggs) [](#method-i-composite)
         
Perform a composite aggregation.

This method is used to perform a composite aggregation, which allows you to collect terms or histogram aggregations on high cardinality fields. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:sources:` The Array representing the sources to use for the composite aggregation.
    - `:size:` The Integer representing the size of the composite aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified composite aggregation.

---

### Examples

#### Composite aggregation

```ruby
  Model.composite(:my_agg, {sources: [...], size: 100})
  Model.composite(:my_agg, {sources: [...], size: 100}, aggs: {...})
```  
        
---

