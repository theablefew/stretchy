# module Stretchy::Relations::QueryMethods [](#module-Stretchy::Relations::QueryMethods) [](#top)
 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **MULTI_VALUE_METHODS[](#MULTI_VALUE_METHODS)** | Not documented |
 | **SINGLE_VALUE_METHODS[](#SINGLE_VALUE_METHODS)** | Not documented |
 | **KEYWORD_AGGREGATION_FIELDS[](#KEYWORD_AGGREGATION_FIELDS)** | This code is responsible for handling terms in the query. If terms are used, we assume that the field is a keyword field and append .keyword to the field name.

For example, a query like this: {terms: {field: ‘gender’}} or nested aggs like this: {terms: {field: ‘gender’}, aggs: {name: {terms: {field: ‘position.name’}}}} should be converted to this: {terms: {field: ‘gender.keyword’}, aggs: {name: {terms: {field: ‘position.name.keyword’}}}}

Date histograms are handled like this: {date\_histogram: {field: ‘created\_at’, interval: ‘day’}}

TODO: There may be cases where we don’t want to add .keyword to the field and there should be a way to override this |
 | **VALID_DIRECTIONS[](#VALID_DIRECTIONS)** | Not documented |
 ## Public Instance Methods
 ### bind(value) [](#method-i-bind)
 ### build_where(opts, other = []) [](#method-i-build_where)
 ### extending(*modules, &block) [](#method-i-extending)
 ### field(*args) [](#method-i-field)
 ### fields(*args) [](#method-i-fields)
 ### filter_query(name, options = {}, &block) [](#method-i-filter_query)
 Adds a filter to the query.

This method supports all filters supported by Elasticsearch.

@overload [`filter_query`](QueryMethods.html#method-i-filter_query)(type, opts) @param type [Symbol] the type of filter to add (:range, :term, etc.) @param opts [Hash] a hash containing the attribute and value to filter by

@example Model.filter\_query(:range, age: {gte: 30}) Model.filter\_query(:term, color: :blue)

@return [Stretchy::Relation] a new relation, which reflects the filter

 ### has_field(field) [](#method-i-has_field)
 Checks if a field exists in the documents.

This is a helper for the exists filter in Elasticsearch, which returns documents that have at least one non-null value in the specified field.

field:: [Symbol, String] the field to check for existence

Example: Model.has\_field(:name)

### Returns[¶](#method-i-has_field-label-Returns) [↑](#top)

Returns a new ActiveRecord::Relation, which reflects the exists filter

 ### highlight(*args) [](#method-i-highlight)
 Highlights the specified fields in the search results.

args:: [Hash] The fields to highlight. Each field is a key in the hash, and the value is another hash specifying the type of highlighting. For example, ‘{body: {type: :plain}}` will highlight the ’body’ field with plain type highlighting.

Example: Model.where(body: “turkey”).highlight(:body)

### Returns[¶](#method-i-highlight-label-Returns) [↑](#top)

Returns a [`Stretchy::Relation`](../Relation.html) object, which can be used for chaining further query methods.

 ### limit(args) [](#method-i-limit)
 Alias for {#size} @see [`size`](QueryMethods.html#method-i-size)

 ### must(opts = :chain, *rest) [](#method-i-must)
 Alias for {#where} @see [`where`](QueryMethods.html#method-i-where)

 ### must_not(opts = :chain, *rest) [](#method-i-must_not)
 Adds negated conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to exclude.

opts:: [Hash] a hash containing attribute-value pairs to exclude rest:: [Array\<Hash\>] additional arguments (not normally used)

Example: Model.must\_not(color: ‘blue’, size: :large)

### Returns[¶](#method-i-must_not-label-Returns) [↑](#top)

Returns a new relation, which reflects the negated conditions See: [`where_not`](QueryMethods.html#method-i-where_not)

 ### none() [](#method-i-none)
 ### Returns[¶](#method-i-none-label-Returns) [↑](#top)

Returns a chainable relation with zero records.

 ### or_filter(name, options = {}, &block) [](#method-i-or_filter)
 @deprecated in elasticsearch 7.x+ use {#filter\_query} instead

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

attribute:: The Symbol attribute to sort by. direction:: The Symbol direction to sort in (:asc or :desc). params:: The Hash attributes to sort by (default: {}):

```
:attribute:: The Symbol attribute name as key to sort by.
```

options:: The Hash containing possible sorting options (default: {}):

```
:order:: The Symbol direction to sort in (:asc or :desc).
:mode:: The Symbol mode to use for sorting (:avg, :min, :max, :sum, :median).
:numeric_type:: The Symbol numeric type to use for sorting (:double, :long, :date, :date_nanos).
:missing:: The Symbol value to use for documents without the field.
:nested:: The Hash nested sorting options (default: {}):
 :path:: The String path to the nested object.
 :filter:: The Hash filter to apply to the nested object.
 :max_children:: The Hash maximum number of children to consider per root document when picking the sort value. Defaults to unlimited.
```

### Returns[¶](#method-i-order-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../Relation.html) with the specified order. See: [`sort`](QueryMethods.html#method-i-sort)

 ### query_string(opts = :chain, *rest) [](#method-i-query_string)
 Adds a query string to the search.

The query string uses Elasticsearch’s Query String Query syntax, which includes a series of terms and operators. Terms can be single words or phrases. Operators include AND, OR, and NOT, among others. Field names can be included in the query string to search for specific values in specific fields. (e.g. “eye\_color: green”) The default operator between terms are treated as OR operators.

query:: [String] the query string rest:: [Array] additional arguments (not normally used)

Example: Model.query\_string(“((big cat) OR (domestic cat)) AND NOT panther eye\_color: green”)

### Returns[¶](#method-i-query_string-label-Returns) [↑](#top)

Returns a new relation, which reflects the query string

 ### regexp(args) [](#method-i-regexp)
 Adds a regexp condition to the query.

@param field [Hash] the field to filter by and the Regexp to match @param opts [Hash] additional options for the regexp query - :flags [String] the flags to use for the regexp query (e.g. ‘ALL’) - :use\_keyword [Boolean] whether to use the .keyword field for the regexp query. Default: true - :case\_insensitive [Boolean] whether to use case insensitive matching. If the regexp has ignore case flag ‘/regex/i`, this is automatically set to true - :max\_determinized\_states [Integer] the maximum number of states that the regexp query can produce - :rewrite [String] the rewrite method to use for the regexp query

@example Model.regexp(:name, /john|jane/) Model.regexp(:name, /john|jane/i) Model.regexp(:name, /john|jane/i, flags: ‘ALL’)

@return [Stretchy::Relation] a new relation, which reflects the regexp condition @see [`where`](QueryMethods.html#method-i-where)

 ### should(opts = :chain, *rest) [](#method-i-should)
 Adds optional conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to match optionally.

rest:: [Array\<Hash\>] additional keywords containing attribute-value pairs to match optionally

Example: Model.should(color: :pink, size: :medium)

### Returns[¶](#method-i-should-label-Returns) [↑](#top)

Returns a new relation, which reflects the optional conditions

 ### size(args) [](#method-i-size)
 Sets the maximum number of records to be retrieved.

args:: The maximum number of records to retrieve.

Example: Model.size(10)

### Returns[¶](#method-i-size-label-Returns) [↑](#top)

Returns a new relation, which reflects the limit. See: [`limit`](QueryMethods.html#method-i-limit)

 ### skip_callbacks(*args) [](#method-i-skip_callbacks)
 Sets the maximum number of records to be retrieved.

@param args [Integer] the maximum number of records to retrieve

@example Model.size(10)

@return [ActiveRecord::Relation] a new relation, which reflects the limit @see [`limit`](QueryMethods.html#method-i-limit)

 ### sort(*args) [](#method-i-sort)
 Alias for {#order} @see [`order`](QueryMethods.html#method-i-order)

 ### source(*args) [](#method-i-source)
 Controls which fields of the source are returned.

This method supports source filtering, which allows you to include or exclude fields from the source. You can specify fields directly, use wildcard patterns, or use an object containing arrays of includes and excludes patterns.

If the includes property is specified, only source fields that match one of its patterns are returned. You can exclude fields from this subset using the excludes property.

If the includes property is not specified, the entire document source is returned, excluding any fields that match a pattern in the excludes property.

opts:: [Hash, Boolean] a hash containing :includes and/or :excludes arrays, or a boolean indicating whether to include the source

Example: Model.source(includes: [:name, :email]) Model.source(excludes: [:name, :email]) Model.source(false) # don’t include source

### Returns[¶](#method-i-source-label-Returns) [↑](#top)

Returns a new relation, which reflects the source filtering

 ### where(opts = :chain, *rest) [](#method-i-where)
 Adds conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to match.

rest:: [Array\<Hash\>] keywords containing attribute-value pairs to match

Example: Model.where(price: 10, color: :green)

```
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

.where acts as a convienence method for adding conditions to the query. It can also be used to add range , regex, terms, and id queries through shorthand parameters.

@example Model.where(price: {gte: 10, lte: 20}) Model.where(age: 19..33) Model.where(color: /gr(a|e)y/) Model.where(id: [10, 22, 18]) Model.where(names: [‘John’, ‘Jane’])

@return [ActiveRecord::Relation, WhereChain] a new relation, which reflects the conditions, or a [`WhereChain`](QueryMethods/WhereChain.html) if opts is :chain @see [`must`](QueryMethods.html#method-i-must)

 ### where_not(opts = :chain, *rest) [](#method-i-where_not)
 Alias for {#must\_not} @see [`must_not`](QueryMethods.html#method-i-must_not)

 