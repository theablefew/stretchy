# Stretchy::Relations::AggregationMethods::Stats [](#module-Stretchy::Relations::AggregationMethods::Stats) [](#top)

    

# Public Instance Methods

      
## stats(name, options = {}, *aggs) [](#method-i-stats)
         
Perform a stats aggregation.

This method is used to perform a stats aggregation, which allows you to compute aggregate statistics over your data set, such as count, min, max, sum, and average. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the stats aggregation.
    - `:missing:` The value to use for the stats aggregation when a field is missing in a document. Example: missing: 10
    - `:script:` The Hash representing the script to use for the stats aggregation. Example: script: {source: "doc['field_name'].value", lang: "painless"}
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified stats aggregation.

---

### Examples

#### Stats aggregation

```ruby
  Model.stats(:my_agg, {field: 'field_name'})
  Model.stats(:my_agg, {field: 'field_name'}, aggs: {...})
```  
        
---

