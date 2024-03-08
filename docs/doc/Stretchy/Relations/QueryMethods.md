# module Stretchy::Relations::QueryMethods [](#module-Stretchy::Relations::QueryMethods) [](#top)
 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **MULTI_VALUE_METHODS[](#MULTI_VALUE_METHODS)** | Not documented |
 | **SINGLE_VALUE_METHODS[](#SINGLE_VALUE_METHODS)** | Not documented |
 | **KEYWORD_AGGREGATION_FIELDS[](#KEYWORD_AGGREGATION_FIELDS)** | This code is responsible for handling terms in the query. If terms are used, we assume that the field is a keyword field and append .keyword to the field name.

For example, a query like this:

```
{terms:{field:'gender'}}
```

or nested aggs like this:

```
{terms:{field:'gender'},aggs:{name:{terms:{field:'position.name'}}}}
```

should be converted to this:

```
{terms:{field:'gender.keyword'},aggs:{name:{terms:{field:'position.name.keyword'}}}}
```

Date histograms are handled like this:

```
{date\_histogram:{field:'created\_at',interval:'day'}}
```

TODO: There may be cases where we don’t want to add .keyword to the field and there should be a way to override this |
 | **VALID_DIRECTIONS[](#VALID_DIRECTIONS)** | Not documented |
 ## Public Instance Methods
 ### aggregation(name, options = {}, &block) [](#method-i-aggregation)
 Adds an aggregation to the query.

<dl class="rdoc-list note-list">
<dt>name
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Symbol, String
</dt>
<dd>
<p>the name of the aggregation</p>
</dd>
</dl>
</dd>
<dt>options
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Hash
</dt>
<dd>
<p>a hash of options for the aggregation</p>
</dd>
</dl>
</dd>
<dt>block
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Proc
</dt>
<dd>
<p>an optional block to further configure the aggregation</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.aggregation(:avg\_price,field::price)Model.aggregation(:price\_ranges)dorangefield::price,ranges:[{to:100}, {from:100,to:200}, {from:200}]end
```

Aggregation results are available in the ‘aggregations` method of the results under name provided in the aggregation.

Example:

```
results=Model.where(color::blue).aggregation(:avg\_price,field::price)results.aggregations.avg\_price
```

Returns a new [`Stretchy::Relation`](../Relation.html)

 ### bind(value) [](#method-i-bind)
 ### build_where(opts, other = []) [](#method-i-build_where)
 ### extending(*modules, &block) [](#method-i-extending)
 ### field(*args) [](#method-i-field)
 ### fields(*args) [](#method-i-fields)
 ### filter(name, options = {}, &block) [](#method-i-filter)
 Adds a filter to the query.

This method supports all filters supported by Elasticsearch.

<dl class="rdoc-list note-list">
<dt>type
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Symbol
</dt>
<dd>
<p>the type of filter to add (:range, :term, etc.)</p>
</dd>
</dl>
</dd>
<dt>opts
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Hash
</dt>
<dd>
<p>a hash containing the attribute and value to filter by</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.filter(:range,age:{gte:30})Model.filter(:term,color::blue)
```

Returns a new relation, which reflects the filter

 ### has_field(field) [](#method-i-has_field)
 Checks if a field exists in the documents.

This is a helper for the exists filter in Elasticsearch, which returns documents that have at least one non-null value in the specified field.

<dl class="rdoc-list note-list">
<dt>field
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Symbol, String
</dt>
<dd>
<p>the field to check for existence</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.has\_field(:name)
```

Returns a new ActiveRecord::Relation, which reflects the exists filter

 ### highlight(*args) [](#method-i-highlight)
 Highlights the specified fields in the search results.

<dl class="rdoc-list note-list">
<dt>args
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Hash
</dt>
<dd>
<p>The fields to highlight. Each field is a key in the hash,</p>
</dd>
</dl>
</dd>
</dl>
```
and the value is another hash specifying the type of highlighting.
For example, `{body: {type: :plain}}` will highlight the 'body' field
with plain type highlighting.
```

Example:

```
Model.where(body:"turkey").highlight(:body)
```

Returns a [`Stretchy::Relation`](../Relation.html) object, which can be used

```
for chaining further query methods.
```
 ### limit(args) [](#method-i-limit)
 Alias for {#size} @see [`size`](QueryMethods.html#method-i-size)

 ### must(opts = :chain, *rest) [](#method-i-must)
 Alias for {#where} @see [`where`](QueryMethods.html#method-i-where)

 ### must_not(opts = :chain, *rest) [](#method-i-must_not)
 Adds negated conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to exclude.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Hash
</dt>
<dd>
<p>a hash containing attribute-value pairs to exclude</p>
</dd>
</dl>
</dd>
<dt>rest
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Array&lt;Hash&gt;
</dt>
<dd>
<p>additional arguments (not normally used)</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.must\_not(color:'blue',size::large)
```

Returns a new relation, which reflects the negated conditions See: [`where_not`](QueryMethods.html#method-i-where_not)

 ### none() [](#method-i-none)
 Returns a chainable relation with zero records.

 ### or_filter(name, options = {}, &block) [](#method-i-or_filter)
 @deprecated in elasticsearch 7.x+ use {#filter} instead

 ### order(*args) [](#method-i-order)
 Allows you to add one or more sorts on specified fields.

Examples:

```
Model.order(created_at: :asc)
# Elasticsearch equivalent
#=> "sort" : [{"created_at" : "asc"}]

Model.order(age: :desc, name: :asc, price: {order: :desc, mode: :avg})
# Elasticsearch equivalent
#=> "sort" : [
 { "price" : {"order" : "desc", "mode": "avg"}},
 { "name" : "asc" },
 { "age" : "desc" }
 ]
```
<dl class="rdoc-list note-list">
<dt>attribute
</dt>
<dd>
<p>The Symbol attribute to sort by.</p>
</dd>
<dt>direction
</dt>
<dd>
<p>The Symbol direction to sort in (:asc or :desc).</p>
</dd>
<dt>params
</dt>
<dd>
<p>The Hash attributes to sort by (default: {}): :attribute - The Symbol attribute name as key to sort by.</p>
</dd>
<dt>options
</dt>
<dd>
<p>The Hash containing possible sorting options (default: {}): :order - The Symbol direction to sort in (:asc or :desc). :mode - The Symbol mode to use for sorting (:avg, :min, :max, :sum, :median). :numeric_type - The Symbol numeric type to use for sorting (:double, :long, :date, :date_nanos). :missing - The Symbol value to use for documents without the field. :nested - The Hash nested sorting options (default: {}):</p>

<pre>:path - The String path to the nested object.
:filter - The Hash filter to apply to the nested object.
:max_children - The Hash maximum number of children to consider per root document when picking the sort value. Defaults to unlimited.</pre>
</dd>
</dl>

Returns a new [`Stretchy::Relation`](../Relation.html) with the specified order. See: [`sort`](QueryMethods.html#method-i-sort)

 ### query_string(opts = :chain, *rest) [](#method-i-query_string)
 Adds a query string to the search.

The query string uses Elasticsearch’s Query String Query syntax, which includes a series of terms and operators. Terms can be single words or phrases. Operators include AND, OR, and NOT, among others. Field names can be included in the query string to search for specific values in specific fields. (e.g. “eye\_color: green”) The default operator between terms are treated as OR operators.

<dl class="rdoc-list note-list">
<dt>query
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>String
</dt>
<dd>
<p>the query string</p>
</dd>
</dl>
</dd>
<dt>rest
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Array
</dt>
<dd>
<p>additional arguments (not normally used)</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.query\_string("((big cat) OR (domestic cat)) AND NOT panther eye\_color: green")
```

Returns a new relation, which reflects the query string

 ### should(opts = :chain, *rest) [](#method-i-should)
 Adds optional conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to match optionally.

<dl class="rdoc-list note-list">
<dt>rest
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Array&lt;Hash&gt;
</dt>
<dd>
<p>additional keywords containing attribute-value pairs to match optionally</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.should(color::pink,size::medium)
```

Returns a new relation, which reflects the optional conditions

 ### size(args) [](#method-i-size)
 Sets the maximum number of records to be retrieved.

<dl class="rdoc-list note-list">
<dt>args
</dt>
<dd>
<p>The maximum number of records to retrieve.</p>
</dd>
</dl>

Example:

```
Model.size(10)
```

Returns a new relation, which reflects the limit. See: [`limit`](QueryMethods.html#method-i-limit)

 ### skip_callbacks(*args) [](#method-i-skip_callbacks)
 Sets the maximum number of records to be retrieved.

@param args [Integer] the maximum number of records to retrieve

@example

```
Model.size(10)
```

@return [ActiveRecord::Relation] a new relation, which reflects the limit @see [`limit`](QueryMethods.html#method-i-limit)

 ### sort(*args) [](#method-i-sort)
 Alias for {#order} @see [`order`](QueryMethods.html#method-i-order)

 ### source(*args) [](#method-i-source)
 Controls which fields of the source are returned.

This method supports source filtering, which allows you to include or exclude fields from the source. You can specify fields directly, use wildcard patterns, or use an object containing arrays of includes and excludes patterns.

If the includes property is specified, only source fields that match one of its patterns are returned. You can exclude fields from this subset using the excludes property.

If the includes property is not specified, the entire document source is returned, excluding any fields that match a pattern in the excludes property.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Hash, Boolean
</dt>
<dd>
<p>a hash containing :includes and/or :excludes arrays, or a boolean indicating whether to include the source</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.source(includes:[:name,:email])Model.source(excludes:[:name,:email])Model.source(false)# don't include source
```

Returns a new relation, which reflects the source filtering

 ### where(opts = :chain, *rest) [](#method-i-where)
 Adds conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to match.

<dl class="rdoc-list note-list">
<dt>rest
</dt>
<dd>
<dl class="rdoc-list label-list">
<dt>Array&lt;Hash&gt;
</dt>
<dd>
<p>keywords containing attribute-value pairs to match</p>
</dd>
</dl>
</dd>
</dl>

Example:

```
Model.where(price: 10, color: :green)

# Elasticsearch equivalent
# => "query" : {
 "bool" : {
 "must" : [
 { "term" : { "price" : 10 } },
 { "term" : { "color" : "green" } }
 ]
 }
 }
```

Returns a new relation, which reflects the conditions, or a [`WhereChain`](QueryMethods/WhereChain.html) if opts is :chain See: [`must`](QueryMethods.html#method-i-must)

 ### where_not(opts = :chain, *rest) [](#method-i-where_not)
 Alias for {#must\_not} @see [`must_not`](QueryMethods.html#method-i-must_not)

 