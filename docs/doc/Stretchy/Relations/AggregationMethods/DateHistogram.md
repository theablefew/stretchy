# Stretchy::Relations::AggregationMethods::DateHistogram [](#module-Stretchy::Relations::AggregationMethods::DateHistogram) [](#top)

    

# Public Instance Methods

      
## date_histogram(name, options = {}, *aggs) [](#method-i-date_histogram)
         
Perform a date_histogram aggregation.

This method is used to perform a date_histogram aggregation, which allows you to aggregate time-based data by a certain interval. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the date_histogram aggregation.
    - `:interval:` The String representing the interval for the date_histogram aggregation.
    - `:calendar_interval:` The Symbol representing the calendar interval for the date_histogram aggregation.
    - `:format:` The String representing the format for the date_histogram aggregation.
    - `:time_zone:` The String representing the time zone for the date_histogram aggregation.
    - `:min_doc_count:` The Integer representing the minimum document count for the date_histogram aggregation.
    - `:extended_bounds:` The Hash representing the extended bounds for the date_histogram aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified date_histogram aggregation.

---

### Examples

#### Date_histogram aggregation

```ruby
  Model.date_histogram(:my_agg, {field: 'date', interval: 'month', format: 'MM-yyyy', time_zone: 'UTC'})
  Model.date_histogram(:my_agg, {field: 'date', calendar_interval: :month, format: 'MM-yyyy', time_zone: 'UTC'}, aggs: {...})
```

Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.

```ruby
  results = Model.where(color: :blue).date_histogram(:my_agg, {field: 'date', interval: 'month', format: 'MM-yyyy', time_zone: 'UTC'})
  results.aggregations.my_agg
```  
        
---

