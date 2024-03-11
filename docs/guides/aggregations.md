# Aggregations

Aggregations in Elasticsearch allow you to get summary information about your data. For example, you can use aggregations to count the number of records that match certain criteria, calculate the average value of a field, find the minimum or maximum value, and more.


When performing aggregations it's good practice to set `size(0)` if you don't need the source documents.

```ruby
results = Profile.aggregation(:flagged_counts, terms: {field: :flagged}).size(0)
```

Aggregation results are available on the results aggregations object by the name provided to the aggregation:

```ruby
results.aggregations.flagged_counts
```

returns:
```ruby
{
  "doc_count_error_upper_bound"=>0,
  "sum_other_doc_count"=>0,
  "buckets"=>[
    {"key"=>"true", "doc_count"=>123},
    {"key"=>"false", "doc_count"=>456}
  ]
}
```

> You can access the entire structure through dot notation. `aggregations.flagged_counts.buckets.first.doc_count` => `123`


--- 

In Stretchy, you use the `aggregation` method to define aggregations. Here are some examples:

### Count by status 

if you have a `status` field and you want to count how many records there are for each status, you can use a terms aggregation:
```ruby
profile.aggregation(:status_count, terms: { field: :status })
```


### Average Age

If you have an age field and you want to calculate the average age, you can do this:

```ruby
Profile.aggregation(:average_age, avg: { field: :age })
```

### Minimum and Maximum Age

If you want to find the minimum and maximum age, you can do this:

```ruby
Profile.aggregation(:min_age, min: { field: :age })
Profile.aggregation(:max_age, max: { field: :age })
```

### Date Histogram

If you have a `created_at` field and you want to count how many profiles were created in each month, you can do this:
```ruby
Profile.aggregation(:profiles_over_time, date_histogram: { field: :created_at, interval: 'month' })
```

In these examples, the first argument to the aggregation method is the name of the aggregation, and the second argument is a hash that defines the aggregation. The key of the hash is the type of the aggregation (terms, avg, min, max, or date_histogram), and the value is another hash that specifies the field to aggregate on and other options.

## Named Aggregation Helpers

The above shows how to use the `aggregation` method directly, but Stretchy makes working with named aggregations even easier. Named aggregation helpers make calling the aggregation you want a breeze.

The documentation goes into depth for all available [aggregation types](/doc/stretchy/relations/AggregationMethods)

### Percentiles

The percentiles aggregation method calculates the percentiles of a numeric field. For example, if you want to calculate the 25th, 50th, and 75th percentiles of the age field, you can do this:
```ruby
Profile.percentiles(:age_percentiles, field: :age, percents: [25, 50, 75])
```

### Extended Stats

The extended_stats aggregation method calculates several statistical measures of a numeric field, including the count, min, max, sum, average, sum of squares, variance, standard deviation, and bounds. For example, if you want to calculate these measures for the age field, you can do this:

```ruby
Profile.extended_stats(:age_stats, field: :age)
```

### Date Range

The date_range aggregation method groups documents by whether their date field falls within specified ranges. For example, if you want to count how many profiles were created before and after a certain date, you can do this:
```ruby
Profile.date_range(:created_at_range, field: :created_at, ranges: [{ to: '2022-01-01' }, { from: '2022-01-01' }])
```

### Significant Terms

The significant_terms aggregation method finds the terms that appear more often in the documents that match your query than in the documents that don't. For example, if you want to find the tags that are significantly associated with profiles that have a status of "active", you can do this:
```ruby
Profile.where(status: 'active').significant_terms(:significant_tags, field: :tags)
```
In these examples, the first argument to the aggregation method is the name of the aggregation, and the second argument is a hash that specifies the field to aggregate on and other options. The exact options depend on the aggregation method.

## Nested Aggregations

Elasticsearch supports complex aggregations by allowing you to nest sub-aggregations within top-level aggregations. These sub-aggregations operate within the context of the parent aggregation, allowing you to refine and group your data in various ways.

There are three main types of aggregations in Elasticsearch: bucket, metric, and pipeline aggregations.

#### Bucket Aggregations 
These aggregations create buckets or sets of documents based on certain criteria. Examples include `terms`, `date_histogram`, `range`, and `significant_terms` aggregations. Each bucket effectively defines a document set, and any sub-aggregations operate within the context of that set.

For example, you could use a terms aggregation to group documents by the status field, and then use a sub-aggregation to calculate the average age within each status group:
```ruby
Profile.aggregation(:status_avg_age, terms: { field: :status }, aggs: { avg_age: { avg: { field: :age } } })
```

#### Metric Aggregations
 These aggregations perform calculations on the documents in each bucket, producing a single numeric result. Examples include `avg`, `sum`, `min`, `max`, and `extended_stats`.

For example, you could use a terms aggregation to group documents by the status field, and then use a max sub-aggregation to find the maximum age within each status group:
```ruby
Profile.aggregation(:status_max_age, terms: { field: :status }, aggs: { max_age: { max: { field: :age } } })
```

#### Pipeline Aggregations
These aggregations perform calculations on the results of other aggregations, allowing you to create complex summaries of your data. Examples include `avg_bucket`, `sum_bucket`, `min_bucket`, `max_bucket`, and `stats_bucket`.

For example, you could use a date_histogram aggregation to count documents by month, and then use a sum_bucket sub-aggregation to calculate the total count over all months:
```ruby
Profile.aggregation(:total_count_over_time, date_histogram: { field: :created_at, interval: 'month' }, aggs: { total_count: { sum_bucket: { buckets_path: '_count' } } })
# or
Profile.date_histogram(:total_count_over_time, {field: :created_at, interval: :month}, aggs: {total_count: { sum_bucket: { buckets_path: '_count' } } })
```

In these examples, the aggs option is used to define sub-aggregations. The key is the name of the sub-aggregation, and the value is a hash that defines the sub-aggregation.