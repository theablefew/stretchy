# Stretchy::Relations::AggregationMethods::Avg [](#module-Stretchy::Relations::AggregationMethods::Avg) [](#top)

    

# Public Instance Methods

      
## avg(name, options = {}, *aggs) [](#method-i-avg)
         
Perform an average aggregation.

This method is used to calculate the average of a numeric field. It accepts a name for the aggregation and a hash of options for the aggregation.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The Symbol or String representing the field to calculate the average on.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified average aggregation.

---

### Examples

#### Average aggregation

```ruby
  Model.avg(:average_price, field: :price)
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).avg(:average_price, field: :price)
  results.aggregations.average_price
```  
        
---

