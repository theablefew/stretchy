# Stretchy::Relations::AggregationMethods::TopMetrics [](#module-Stretchy::Relations::AggregationMethods::TopMetrics) [](#top)

    

# Public Instance Methods

      
## top_metrics(name, options = {}, *aggs) [](#method-i-top_metrics)
         
Perform a top_metrics aggregation.

This method is used to perform a top_metrics aggregation, which allows you to return the top metrics for each bucket of a parent aggregation. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:metrics:` The Array of Hashes representing the metrics to use for the top_metrics aggregation. Example: metrics: [{field: 'field_name', type: 'max'}, {field: 'field_name', type: 'min'}]
    - `:field:` The String representing the field to use for the top_metrics aggregation (optional).
    - `:size:` The Integer representing the size for the top_metrics aggregation (optional).
    - `:sort:` The Hash or Array representing the sort for the top_metrics aggregation (optional).
    - `:missing:` The value to use for the top_metrics aggregation when a field is missing in a document (optional).
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified top_metrics aggregation.

---

### Examples

#### Top_metrics aggregation

```ruby
  Model.top_metrics(:my_agg, {metrics: [{field: 'field_name', type: 'max'}, {field: 'field_name', type: 'min'}]})
  Model.top_metrics(:my_agg, {metrics: [{field: 'field_name', type: 'max'}, {field: 'field_name', type: 'min'}]}, aggs: {...})
```  
        
---

