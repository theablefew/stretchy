# Stretchy::Relations::AggregationMethods::BucketSelector [](#module-Stretchy::Relations::AggregationMethods::BucketSelector) [](#top)

    

# Public Instance Methods

      
## bucket_selector(name, options = {}, *aggs) [](#method-i-bucket_selector)
         
Perform a bucket_selector aggregation.

This method is used to filter buckets of a parent multi-bucket aggregation. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:script:` The String representing the script to determine whether the current bucket will be retained.
    - `:buckets_path:` The Hash representing the paths to the buckets on which to perform computations.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified bucket_selector aggregation.

---

### Examples

#### Bucket_selector aggregation

```ruby
  Model.bucket_selector(:sales_bucket_filter, script: "params.totalSales > 200", buckets_path: {totalSales: "totalSales"})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).bucket_selector(:sales_bucket_filter, script: "params.totalSales > 200", buckets_path: {totalSales: "totalSales"})
  results.aggregations.sales_bucket_filter
```  
        
---

