# Stretchy::Relations::AggregationMethods::BucketScript [](#module-Stretchy::Relations::AggregationMethods::BucketScript) [](#top)

    

# Public Instance Methods

      
## bucket_script(name, options = {}, *aggs) [](#method-i-bucket_script)
         
Perform a bucket_script aggregation.

This method is used to perform computations on the results of other aggregations. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:buckets_path:` The Hash representing the paths to the buckets on which to perform computations.
    - `:script:` The String representing the script to execute.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified bucket_script aggregation.

---

### Examples

#### Bucket_script aggregation

```ruby
  Model.bucket_script(:total_sales, script: "params.tShirtsSold * params.price", buckets_path: {tShirtsSold: "tShirtsSold", price: "price"})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).bucket_script(:total_sales, script: "params.tShirtsSold * params.price", buckets_path: {tShirtsSold: "tShirtsSold", price: "price"})
  results.aggregations.total_sales
```  
        
---

