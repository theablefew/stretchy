# Stretchy::Relations::AggregationMethods::GeoCentroid [](#module-Stretchy::Relations::AggregationMethods::GeoCentroid) [](#top)

    

# Public Instance Methods

      
## geo_centroid(name, options = {}, *aggs) [](#method-i-geo_centroid)
         
Perform a geo_centroid aggregation.

This method is used to perform a geo_centroid aggregation, which allows you to find the central point (centroid) of all geo_point values for a particular field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the geo_centroid aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified geo_centroid aggregation.

---

### Examples

#### Geo_centroid aggregation

```ruby
  Model.geo_centroid(:my_agg, {field: 'location_field'})
  Model.geo_centroid(:my_agg, {field: 'location_field'}, aggs: {...})
```  
        
---

