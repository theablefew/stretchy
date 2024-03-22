# Stretchy::Relations::AggregationMethods::PercentileRanks [](#module-Stretchy::Relations::AggregationMethods::PercentileRanks) [](#top)

    

# Public Instance Methods

      
## percentile_ranks(name, options = {}, *aggs) [](#method-i-percentile_ranks)
         
Perform a percentile_ranks aggregation.

This method is used to perform a percentile_ranks aggregation, which allows you to calculate the percentile rank for each value in a set of values. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the percentile_ranks aggregation.
    - `:values:` The Array of values to use for the percentile_ranks aggregation.
    - `:keyed:` The Boolean that associates a unique string key with each bucket and returns the ranges as a hash rather than an array. Default is true.
    - `:script:` The Hash representing the script to use for the percentile_ranks aggregation. Example: script: {source: "doc['field_name'].value", lang: "painless"}
    - `:hdr:` The Hash representing the hdr to use for the percentile_ranks aggregation. Example: hdr: {number_of_significant_value_digits: 3}
    - `:missing:` The value to use for the percentile_ranks aggregation when a field is missing in a document. Example: missing: 10
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified percentile_ranks aggregation.

---

### Examples

#### Percentile_ranks aggregation

```ruby
  Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]})
  Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]}, aggs: {...})
```  
        
---

