# Stretchy::Relations::AggregationMethods::Histogram [](#module-Stretchy::Relations::AggregationMethods::Histogram) [](#top)

    

# Public Instance Methods

      
## histogram(name, options = {}, *aggs) [](#method-i-histogram)
         
Perform a histogram aggregation.

This method is used to perform a histogram aggregation, which allows you to aggregate data into buckets of a certain interval. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the histogram aggregation.
    - `:interval:` The Integer representing the interval for the histogram aggregation.
    - `:min_doc_count:` The Integer representing the minimum document count for the histogram aggregation.
    - `:extended_bounds:` The Hash representing the extended bounds for the histogram aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified histogram aggregation.

---

### Examples

#### Histogram aggregation

```ruby
  Model.histogram(:my_agg, {field: 'field_name', interval: 5})
  Model.histogram(:my_agg, {field: 'field_name', interval: 5}, aggs: {...})
```  
        
---

