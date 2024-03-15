# module Stretchy::Relations::AggregationMethods [](#module-Stretchy::Relations::AggregationMethods) [](#top)
 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **AGGREGATION_METHODS[](#AGGREGATION_METHODS)** | Not documented |
 ## Public Instance Methods
 ### aggregation(name, options = {}, &block) [](#method-i-aggregation)
 Adds an aggregation to the query.

@param name [Symbol, String] the name of the aggregation @param options [Hash] a hash of options for the aggregation @param block [Proc] an optional block to further configure the aggregation

@example Model.aggregation(:avg\_price, field: :price) Model.aggregation(:price\_ranges) do range field: :price, ranges: [{to: 100}, {from: 100, to: 200}, {from: 200}] end

Aggregation results are available in the ‘aggregations` method of the results under name provided in the aggregation.

@example results = Model.where(color: :blue).aggregation(:avg\_price, field: :price) results.aggregations.avg\_price

@return [Stretchy::Relation] a new relation

 # Public
 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **AGGREGATION_METHODS[](#AGGREGATION_METHODS)** | Not documented |
 ## Public Instance Methods
 ### avg(name, options = {}, *aggs) [](#method-i-avg)
 Perform an avg aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to calculate the average on.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-avg-label-Examples) [↑](#top)

```
Model.aggregation(:average\_price,field::price)
```

### Returns[¶](#method-i-avg-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### bucket_script(name, options = {}, *aggs) [](#method-i-bucket_script)
 Perform a [`bucket_script`](AggregationMethods.html#method-i-bucket_script) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:buckets_path
</dt>
<dd>
<p>The paths to the buckets.</p>
</dd>
<dt>:script
</dt>
<dd>
<p>The script to execute.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-bucket_script-label-Examples) [↑](#top)

```
Model.aggregation(:total\_sales,script:"params.tShirtsSold \* params.price",buckets\_path:{tShirtsSold:"tShirtsSold",price:"price"})
```

### Returns[¶](#method-i-bucket_script-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### bucket_selector(name, options = {}, *aggs) [](#method-i-bucket_selector)
 Perform a [`bucket_selector`](AggregationMethods.html#method-i-bucket_selector) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:script
</dt>
<dd>
<p>The script to determine whether the current bucket will be retained.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-bucket_selector-label-Examples) [↑](#top)

```
Model.aggregation(:sales\_bucket\_filter,script:"params.totalSales \> 200",buckets\_path:{totalSales:"totalSales"})
```

### Returns[¶](#method-i-bucket_selector-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### bucket_sort(name, options = {}, *aggs) [](#method-i-bucket_sort)
 Perform a [`bucket_sort`](AggregationMethods.html#method-i-bucket_sort) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to sort on.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-bucket_sort-label-Examples) [↑](#top)

```
Model.bucket\_sort(:my\_agg, {field:'my\_field'})Model.bucket\_sort(:my\_agg, {field:'my\_field'},aggs:{...})
```

### Returns[¶](#method-i-bucket_sort-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### cardinality(name, options = {}, *aggs) [](#method-i-cardinality)
 Perform a cardinality aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to perform the aggregation on.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-cardinality-label-Examples) [↑](#top)

```
Model.cardinality(:unique\_names, {field:'names'})Model.cardinality(:unique\_names, {field:'names'},aggs:{...})
```

### Returns[¶](#method-i-cardinality-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### children(name, options = {}, *aggs) [](#method-i-children)
 Perform a children aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:type
</dt>
<dd>
<p>The type of children to aggregate.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-children-label-Examples) [↑](#top)

```
Model.children(:my\_agg, {type:'my\_type'})Model.children(:my\_agg, {type:'my\_type'},aggs:{...})
```

### Returns[¶](#method-i-children-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### composite(name, options = {}, *aggs) [](#method-i-composite)
 Perform a composite aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:sources
</dt>
<dd>
<p>The sources to use for the composite aggregation.</p>
</dd>
<dt>:size
</dt>
<dd>
<p>The size of the composite aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-composite-label-Examples) [↑](#top)

```
Model.composite(:my\_agg, {sources:[...],size:100})Model.composite(:my\_agg, {sources:[...],size:100},aggs:{...})
```

### Returns[¶](#method-i-composite-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### date_histogram(name, options = {}, *aggs) [](#method-i-date_histogram)
 Perform a [`date_histogram`](AggregationMethods.html#method-i-date_histogram) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
<dt>:interval
</dt>
<dd>
<p>The interval for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
<dt>:calendar_interval
</dt>
<dd>
<p>The calendar interval for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
<dt>:format
</dt>
<dd>
<p>The format for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
<dt>:time_zone
</dt>
<dd>
<p>The time zone for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
<dt>:min_doc_count
</dt>
<dd>
<p>The minimum document count for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
<dt>:extended_bounds
</dt>
<dd>
<p>The extended bounds for the <a href="AggregationMethods.html#method-i-date_histogram"><code>date_histogram</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-date_histogram-label-Examples) [↑](#top)

```
Model.date\_histogram(:my\_agg, {field:'date',interval:'month',format:'MM-yyyy',time\_zone:'UTC'})Model.date\_histogram(:my\_agg, {field:'date',calendar\_interval::month,format:'MM-yyyy',time\_zone:'UTC'},aggs:{...})
```

### Returns[¶](#method-i-date_histogram-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### date_range(name, options = {}, *aggs) [](#method-i-date_range)
 Perform a [`date_range`](AggregationMethods.html#method-i-date_range) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-date_range"><code>date_range</code></a> aggregation.</p>
</dd>
<dt>:format
</dt>
<dd>
<p>The format for the <a href="AggregationMethods.html#method-i-date_range"><code>date_range</code></a> aggregation.</p>
</dd>
<dt>:time_zone
</dt>
<dd>
<p>The time zone for the <a href="AggregationMethods.html#method-i-date_range"><code>date_range</code></a> aggregation.</p>
</dd>
<dt>:ranges
</dt>
<dd>
<p>The ranges for the <a href="AggregationMethods.html#method-i-date_range"><code>date_range</code></a> aggregation.</p>
</dd>
<dt>:keyed
</dt>
<dd>
<p>The keyed option for the <a href="AggregationMethods.html#method-i-date_range"><code>date_range</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Hash of nested aggregations.</p>
</dd>
</dl>
### Examples[¶](#method-i-date_range-label-Examples) [↑](#top)

```
Model.date\_range(:my\_agg, {field:'date',format:'MM-yyyy',time\_zone:'UTC',ranges:[{to:'now',from:'now-1M'}]})Model.date\_range(:my\_agg, {field:'date',format:'MM-yyyy',time\_zone:'UTC',ranges:[{to:'now',from:'now-1M'}]},aggs:{...})
```

### Returns[¶](#method-i-date_range-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### extended_stats(name, options = {}, *aggs) [](#method-i-extended_stats)
 Perform an [`extended_stats`](AggregationMethods.html#method-i-extended_stats) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-extended_stats"><code>extended_stats</code></a> aggregation.</p>
</dd>
<dt>:sigma
</dt>
<dd>
<p>The sigma for the <a href="AggregationMethods.html#method-i-extended_stats"><code>extended_stats</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-extended_stats-label-Examples) [↑](#top)

```
Model.extended\_stats(:my\_agg, {field:'field\_name',sigma:1.0})Model.extended\_stats(:my\_agg, {field:'field\_name',sigma:1.0},aggs:{...})
```

### Returns[¶](#method-i-extended_stats-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### filter(name, options = {}, *aggs) [](#method-i-filter)
 Perform a filter\_agg aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:filter
</dt>
<dd>
<p>The filter to use for the filter_agg aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-filter-label-Examples) [↑](#top)

```
Model.filter\_agg(:my\_agg, {filter:{...}})Model.filter\_agg(:my\_agg, {filter:{...}},aggs:{...})
```

### Returns[¶](#method-i-filter-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### filters(name, options = {}, *aggs) [](#method-i-filters)
 Perform a filters aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:filters
</dt>
<dd>
<p>The filters to use for the filters aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-filters-label-Examples) [↑](#top)

```
Model.filters(:my\_agg, {filters:{...}})Model.filters(:my\_agg, {filters:{...}},aggs:{...})
```

### Returns[¶](#method-i-filters-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### geo_bounds(name, options = {}, *aggs) [](#method-i-geo_bounds)
 Perform a [`geo_bounds`](AggregationMethods.html#method-i-geo_bounds) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-geo_bounds"><code>geo_bounds</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-geo_bounds-label-Examples) [↑](#top)

```
Model.geo\_bounds(:my\_agg, {field:'location\_field'})Model.geo\_bounds(:my\_agg, {field:'location\_field'},aggs:{...})
```

### Returns[¶](#method-i-geo_bounds-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### geo_centroid(name, options = {}, *aggs) [](#method-i-geo_centroid)
 Perform a [`geo_centroid`](AggregationMethods.html#method-i-geo_centroid) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-geo_centroid"><code>geo_centroid</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-geo_centroid-label-Examples) [↑](#top)

```
Model.geo\_centroid(:my\_agg, {field:'location\_field'})Model.geo\_centroid(:my\_agg, {field:'location\_field'},aggs:{...})
```

### Returns[¶](#method-i-geo_centroid-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### global(name, options = {}, *aggs) [](#method-i-global)
 Perform a global aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}).</p>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-global-label-Examples) [↑](#top)

```
Model.global(:my\_agg)Model.global(:my\_agg, {},aggs:{...})
```

### Returns[¶](#method-i-global-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### histogram(name, options = {}, *aggs) [](#method-i-histogram)
 Perform a histogram aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the histogram aggregation.</p>
</dd>
<dt>:interval
</dt>
<dd>
<p>The interval for the histogram aggregation.</p>
</dd>
<dt>:min_doc_count
</dt>
<dd>
<p>The minimum document count for the histogram aggregation.</p>
</dd>
<dt>:extended_bounds
</dt>
<dd>
<p>The extended bounds for the histogram aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-histogram-label-Examples) [↑](#top)

```
Model.histogram(:my\_agg, {field:'field\_name',interval:5})Model.histogram(:my\_agg, {field:'field\_name',interval:5},aggs:{...})
```

### Returns[¶](#method-i-histogram-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### ip_range(name, options = {}, *aggs) [](#method-i-ip_range)
 Perform an [`ip_range`](AggregationMethods.html#method-i-ip_range) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-ip_range"><code>ip_range</code></a> aggregation.</p>
</dd>
<dt>:ranges
</dt>
<dd>
<p>The ranges to use for the <a href="AggregationMethods.html#method-i-ip_range"><code>ip_range</code></a> aggregation. ranges: [{to: ‘10.0.0.5’}, {from: ‘10.0.0.5’}]</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-ip_range-label-Examples) [↑](#top)

```
Model.ip\_range(:my\_agg, {field:'ip\_field'})Model.ip\_range(:my\_agg, {field:'ip\_field'},aggs:{...})
```

### Returns[¶](#method-i-ip_range-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### max(name, options = {}, *aggs) [](#method-i-max)
 Perform a max aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the max aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-max-label-Examples) [↑](#top)

```
Model.max(:my\_agg, {field:'field\_name'})Model.max(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-max-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### min(name, options = {}, *aggs) [](#method-i-min)
 Perform a min aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the min aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-min-label-Examples) [↑](#top)

```
Model.min(:my\_agg, {field:'field\_name'})Model.min(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-min-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### missing(name, options = {}, *aggs) [](#method-i-missing)
 Perform a missing aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the missing aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-missing-label-Examples) [↑](#top)

```
Model.missing(:my\_agg, {field:'field\_name'})Model.missing(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-missing-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### nested(name, options = {}, *aggs) [](#method-i-nested)
 Perform a nested aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:path
</dt>
<dd>
<p>The path to use for the nested aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-nested-label-Examples) [↑](#top)

```
Model.nested(:my\_agg, {path:'path\_to\_field'})Model.nested(:my\_agg, {path:'path\_to\_field'},aggs:{...})
```

### Returns[¶](#method-i-nested-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### percentile_ranks(name, options = {}, *aggs) [](#method-i-percentile_ranks)
 Perform a [`percentile_ranks`](AggregationMethods.html#method-i-percentile_ranks) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-percentile_ranks"><code>percentile_ranks</code></a> aggregation.</p>
</dd>
<dt>:values
</dt>
<dd>
<p>The values to use for the <a href="AggregationMethods.html#method-i-percentile_ranks"><code>percentile_ranks</code></a> aggregation.</p>
</dd>
<dt>:keyed
</dt>
<dd>
<p>associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true</p>
</dd>
<dt>:script
</dt>
<dd>
<p>The script to use for the <a href="AggregationMethods.html#method-i-percentile_ranks"><code>percentile_ranks</code></a> aggregation. (optional) script: {source: “<a href="'field_name'">doc</a>.value”, lang: “painless”}</p>
</dd>
<dt>:hdr
</dt>
<dd>
<p>The hdr to use for the <a href="AggregationMethods.html#method-i-percentile_ranks"><code>percentile_ranks</code></a> aggregation. (optional) hdr: {number_of_significant_value_digits: 3}</p>
</dd>
<dt>:missing
</dt>
<dd>
<p>The missing to use for the <a href="AggregationMethods.html#method-i-percentile_ranks"><code>percentile_ranks</code></a> aggregation. (optional) missing: 10</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-percentile_ranks-label-Examples) [↑](#top)

```
Model.percentile\_ranks(:my\_agg, {field:'field\_name',values:[1,2,3]})Model.percentile\_ranks(:my\_agg, {field:'field\_name',values:[1,2,3]},aggs:{...})
```

### Returns[¶](#method-i-percentile_ranks-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### percentiles(name, options = {}, *aggs) [](#method-i-percentiles)
 Perform a percentiles aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the percentiles aggregation.</p>
</dd>
<dt>:percents
</dt>
<dd>
<p>The percents to use for the percentiles aggregation. percents: [95, 99, 99.9]</p>
</dd>
<dt>:keyed
</dt>
<dd>
<p>associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true</p>
</dd>
<dt>:tdigest
</dt>
<dd>
<p>The tdigest to use for the percentiles aggregation. (optional) tdigest: {compression: 100, execution_hint: “high_accuracy”}</p>
</dd>
<dt>:compression
</dt>
<dd>
<p>The compression factor to use for the t-digest algorithm. A higher compression factor will yield more accurate percentiles, but will require more memory. The default value is 100.</p>
</dd>
<dt>:execution_hint
</dt>
<dd>
<p>The execution_hint to use for the t-digest algorithm. (optional) execution_hint: “auto”</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-percentiles-label-Examples) [↑](#top)

```
Model.percentiles(:my\_agg, {field:'field\_name',percents:[1,2,3]})Model.percentiles(:my\_agg, {field:'field\_name',percents:[1,2,3]},aggs:{...})
```

### Returns[¶](#method-i-percentiles-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### range(name, options = {}, *aggs) [](#method-i-range)
 Perform a range aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the range aggregation.</p>
</dd>
<dt>:ranges
</dt>
<dd>
<p>The ranges to use for the range aggregation.</p>
</dd>
<dt>:keyed
</dt>
<dd>
<p>associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-range-label-Examples) [↑](#top)

```
Model.range(:my\_agg, {field:'field\_name',ranges:[{from:1,to:2}, {from:2,to:3}]})Model.range(:my\_agg, {field:'field\_name',ranges:[{from:1,to:2}, {from:2,to:3}]},aggs:{...})
```

### Returns[¶](#method-i-range-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### reverse_nested(name, options = {}, *aggs) [](#method-i-reverse_nested)
 Perform a [`reverse_nested`](AggregationMethods.html#method-i-reverse_nested) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}).</p>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-reverse_nested-label-Examples) [↑](#top)

```
Model.reverse\_nested(:my\_agg)Model.reverse\_nested(:my\_agg, {},aggs:{...})
```

### Returns[¶](#method-i-reverse_nested-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### sampler(name, options = {}, *aggs) [](#method-i-sampler)
 Perform a sampler aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:shard_size
</dt>
<dd>
<p>The shard size to use for the sampler aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-sampler-label-Examples) [↑](#top)

```
Model.sampler(:my\_agg, {shard\_size:100})Model.sampler(:my\_agg, {shard\_size:100},aggs:{...})
```

### Returns[¶](#method-i-sampler-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### scripted_metric(name, options = {}, *aggs) [](#method-i-scripted_metric)
 Perform a [`scripted_metric`](AggregationMethods.html#method-i-scripted_metric) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:init_script
</dt>
<dd>
<p>The initialization script for the <a href="AggregationMethods.html#method-i-scripted_metric"><code>scripted_metric</code></a> aggregation.</p>
</dd>
<dt>:map_script
</dt>
<dd>
<p>The map script for the <a href="AggregationMethods.html#method-i-scripted_metric"><code>scripted_metric</code></a> aggregation.</p>
</dd>
<dt>:combine_script
</dt>
<dd>
<p>The combine script for the <a href="AggregationMethods.html#method-i-scripted_metric"><code>scripted_metric</code></a> aggregation.</p>
</dd>
<dt>:reduce_script
</dt>
<dd>
<p>The reduce script for the <a href="AggregationMethods.html#method-i-scripted_metric"><code>scripted_metric</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-scripted_metric-label-Examples) [↑](#top)

```
Model.scripted\_metric(:my\_agg, {init\_script:'...',map\_script:'...',combine\_script:'...',reduce\_script:'...'})Model.scripted\_metric(:my\_agg, {init\_script:'...',map\_script:'...',combine\_script:'...',reduce\_script:'...'},aggs:{...})
```

### Returns[¶](#method-i-scripted_metric-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### significant_terms(name, options = {}, *aggs) [](#method-i-significant_terms)
 Perform a [`significant_terms`](AggregationMethods.html#method-i-significant_terms) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-significant_terms"><code>significant_terms</code></a> aggregation.</p>
</dd>
<dt>:background_filter
</dt>
<dd>
<p>The background filter to use for the <a href="AggregationMethods.html#method-i-significant_terms"><code>significant_terms</code></a> aggregation.</p>
</dd>
<dt>:mutual_information
</dt>
<dd>
<p>The mutual information to use for the <a href="AggregationMethods.html#method-i-significant_terms"><code>significant_terms</code></a> aggregation.</p>
</dd>
<dt>:chi_square
</dt>
<dd>
<p>The chi square to use for the <a href="AggregationMethods.html#method-i-significant_terms"><code>significant_terms</code></a> aggregation.</p>
</dd>
<dt>:gnd
</dt>
<dd>
<p>The gnd to use for the <a href="AggregationMethods.html#method-i-significant_terms"><code>significant_terms</code></a> aggregation.</p>
</dd>
<dt>:jlh
</dt>
<dd>
<p>The jlh to use for the <a href="AggregationMethods.html#method-i-significant_terms"><code>significant_terms</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-significant_terms-label-Examples) [↑](#top)

```
Model.significant\_terms(:my\_agg, {field:'field\_name'})Model.significant\_terms(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-significant_terms-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### stats(name, options = {}, *aggs) [](#method-i-stats)
 Perform a stats aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the stats aggregation.</p>
</dd>
<dt>:missing
</dt>
<dd>
<p>The missing to use for the stats aggregation.</p>
</dd>
<dt>:script
</dt>
<dd>
<p>The script to use for the stats aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-stats-label-Examples) [↑](#top)

```
Model.stats(:my\_agg, {field:'field\_name'})Model.stats(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-stats-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### sum(name, options = {}, *aggs) [](#method-i-sum)
 Perform a sum aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the sum aggregation.</p>
</dd>
<dt>:missing
</dt>
<dd>
<p>The missing to use for the sum aggregation.</p>
</dd>
<dt>:script
</dt>
<dd>
<p>The script to use for the sum aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-sum-label-Examples) [↑](#top)

```
Model.sum(:my\_agg, {field:'field\_name'})Model.sum(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-sum-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### terms(name, options = {}, *aggs) [](#method-i-terms)
 Perform a terms aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the terms aggregation.</p>
</dd>
<dt>:size
</dt>
<dd>
<p>The size for the terms aggregation. (optional)</p>
</dd>
<dt>:min_doc_count
</dt>
<dd>
<p>The minimum document count for the terms aggregation. (optional)</p>
</dd>
<dt>:shard_min_doc_count
</dt>
<dd>
<p>The shard minimum document count for the terms aggregation. (optional)</p>
</dd>
<dt>:show_term_doc_count_error
</dt>
<dd>
<p>The show_term_doc_count_error for the terms aggregation. (optional) default: false</p>
</dd>
<dt>:shard_size
</dt>
<dd>
<p>The shard size for the terms aggregation. (optional)</p>
</dd>
<dt>:order
</dt>
<dd>
<p>The order for the terms aggregation. (optional)</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-terms-label-Examples) [↑](#top)

```
Model.terms(:my\_agg, {field:'field\_name',size:10,min\_doc\_count:1,shard\_size:100})Model.terms(:my\_agg, {field:'field\_name',size:10,min\_doc\_count:1,shard\_size:100},aggs:{...})
```

### Returns[¶](#method-i-terms-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### top_hits(name, options = {}, *aggs) [](#method-i-top_hits)
 Perform a [`top_hits`](AggregationMethods.html#method-i-top_hits) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:size
</dt>
<dd>
<p>The size for the <a href="AggregationMethods.html#method-i-top_hits"><code>top_hits</code></a> aggregation.</p>
</dd>
<dt>:from
</dt>
<dd>
<p>The from for the <a href="AggregationMethods.html#method-i-top_hits"><code>top_hits</code></a> aggregation.</p>
</dd>
<dt>:sort
</dt>
<dd>
<p>The sort for the <a href="AggregationMethods.html#method-i-top_hits"><code>top_hits</code></a> aggregation.</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-top_hits-label-Examples) [↑](#top)

```
Model.top\_hits(:my\_agg, {size:10,sort:{...}})Model.top\_hits(:my\_agg, {size:10,sort:{...}},aggs:{...})
```

### Returns[¶](#method-i-top_hits-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### top_metrics(name, options = {}, *aggs) [](#method-i-top_metrics)
 Perform a [`top_metrics`](AggregationMethods.html#method-i-top_metrics) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:metrics
</dt>
<dd>
<p>The metrics to use for the <a href="AggregationMethods.html#method-i-top_metrics"><code>top_metrics</code></a> aggregation. metrics: [{field: ‘field_name’, type: ‘max’}, {field: ‘field_name’, type: ‘min’]</p>
</dd>
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-top_metrics"><code>top_metrics</code></a> aggregation. (optional)</p>
</dd>
<dt>:size
</dt>
<dd>
<p>The size for the <a href="AggregationMethods.html#method-i-top_metrics"><code>top_metrics</code></a> aggregation. (optional)</p>
</dd>
<dt>:sort
</dt>
<dd>
<p>The sort for the <a href="AggregationMethods.html#method-i-top_metrics"><code>top_metrics</code></a> aggregation. (optional)</p>
</dd>
<dt>:missing
</dt>
<dd>
<p>The missing for the <a href="AggregationMethods.html#method-i-top_metrics"><code>top_metrics</code></a> aggregation. (optional)</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-top_metrics-label-Examples) [↑](#top)

```
Model.top\_metrics(:my\_agg, {metrics:['metric1','metric2']})Model.top\_metrics(:my\_agg, {metrics:['metric1','metric2']},aggs:{...})
```

### Returns[¶](#method-i-top_metrics-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### value_count(name, options = {}, *aggs) [](#method-i-value_count)
 Perform a [`value_count`](AggregationMethods.html#method-i-value_count) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:field
</dt>
<dd>
<p>The field to use for the <a href="AggregationMethods.html#method-i-value_count"><code>value_count</code></a> aggregation.</p>
</dd>
<dt>:script
</dt>
<dd>
<p>The script to use for the <a href="AggregationMethods.html#method-i-value_count"><code>value_count</code></a> aggregation. (optional) script: {source: “<a href="'field_name'">doc</a>.value”, lang: “painless”}</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-value_count-label-Examples) [↑](#top)

```
Model.value\_count(:my\_agg, {field:'field\_name'})Model.value\_count(:my\_agg, {field:'field\_name'},aggs:{...})
```

### Returns[¶](#method-i-value_count-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 ### weighted_avg(name, options = {}, *aggs) [](#method-i-weighted_avg)
 Perform a [`weighted_avg`](AggregationMethods.html#method-i-weighted_avg) aggregation.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<p>The Symbol or String name of the aggregation.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash options used to refine the aggregation (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:value
</dt>
<dd>
<p>The value field to use for the <a href="AggregationMethods.html#method-i-weighted_avg"><code>weighted_avg</code></a> aggregation. {value: { field: ‘price’, missing: 0}}</p>
</dd>
<dt>:weight
</dt>
<dd>
<p>The weight field to use for the <a href="AggregationMethods.html#method-i-weighted_avg"><code>weighted_avg</code></a> aggregation. {weight: { field: ‘weight’, missing: 0}}</p>
</dd>
<dt>:format
</dt>
<dd>
<p>The format for the <a href="AggregationMethods.html#method-i-weighted_avg"><code>weighted_avg</code></a> aggregation. (optional)</p>
</dd>
</dl>
</dd>
<dt>aggs
</dt>
<dd>
<p>The Array of additional nested aggregations (optional).</p>
</dd>
</dl>
### Examples[¶](#method-i-weighted_avg-label-Examples) [↑](#top)

```
Model.weighted\_avg(:my\_agg, {value\_field:'value\_field\_name',weight\_field:'weight\_field\_name'})Model.weighted\_avg(:my\_agg, {value\_field:'value\_field\_name',weight\_field:'weight\_field\_name'},aggs:{...})
```

### Returns[¶](#method-i-weighted_avg-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html).

 