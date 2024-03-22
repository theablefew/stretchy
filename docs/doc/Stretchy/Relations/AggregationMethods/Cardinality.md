# Stretchy::Relations::AggregationMethods::Cardinality [](#module-Stretchy::Relations::AggregationMethods::Cardinality) [](#top)

    

# Public Instance Methods

      
## cardinality(name, options = {}, *aggs) [](#method-i-cardinality)
         
Perform a cardinality aggregation.

This method is used to calculate the cardinality (unique count) of a field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The Symbol or String representing the field to calculate the cardinality on.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified cardinality aggregation.

---

### Examples

#### Cardinality aggregation

```ruby
  Model.cardinality(:unique_names, {field: 'names'})
  Model.cardinality(:unique_names, {field: 'names'}, aggs: {...})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).cardinality(:unique_names, {field: 'names'})
  results.aggregations.unique_names
```  
        
---

