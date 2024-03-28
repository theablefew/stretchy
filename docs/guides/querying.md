# Querying

## Adding Query Conditions 

### Must
>[!TIP|style:flat|label:where]
> `.where` is aliased as `.must` and is provided for familiarity. They are interchangeable in functionality.

The `.where` method is used to filter the documents that should be returned from a search. It adds conditions to the `must` clause of the query, which means that only documents that match all of the conditions will be returned.

The `.where` method is flexible and can accept multiple conditions and different types of expressions. The `.where` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search. Here are some examples of how it can be used:

You can pass one or more key-value pairs to `.where` to search for documents where specific fields have specific values. For example, `Model.where(color: 'blue', title: 'Candy')` will return only documents where the `color` field is 'blue' and the `title` field is 'Candy'.
```ruby
Model.where(color: 'blue', :title: "Candy")
```

>[!INFO|label:Default Behavior|style:flat]
> The default behavior is to create a term query for each argument against keyword fields. 

```ruby
Model.must(file_name: 'rb', content: '.where')
```

```ruby
{
  "query" => {
    "bool" => {
      "must" => [
        {
          "term" => {
            "file_name.keyword" => "rb"
          }
        },
        {
          "term" => {
            "content.keyword" => ".where"
          }
        }
      ]
    }
  }
}
```

For `match` behavior the query can be modified like so:

```ruby
Model.must(match: {file_name: '*.rb', content: '.where'})
#or Model.where(match: {file_name: '*.rb', content: '.where'})
```

```ruby
{
  "query" => {
    "bool" => {
      "must" => [
        {
          "match" => {
            "file_name" => "*.rb"
          }
        },
        {
          "match" => {
            "content" => ".where"
          }
        }
      ]
    }
  }
}
```



##### Ranges
You can use ranges to search for documents where a field's value falls within a certain range. For example,
```ruby
Model.where(date: 2.days.ago...1.day.ago)

Model.where(age: 18..30)

Model.where(price: {gte: 100, lt: 140})
```

##### Regex
You can use regular expressions to search for documents where a field's value matches a certain pattern.
```ruby
Model.where(name: /br.*n/i)
```

##### Terms
You can use an array of values to search for documents where a field's value is in the array.
```ruby
Model.where(name: ['Candy', 'Lilly'])
```

### Should
The `.should` method is used to add conditions to the should clause of the query. This is different from the `.where` and `.filter_query` methods, which add conditions to the `must` and `filter` clauses, respectively.

Conditions in the `should` clause are optional: a document can match any number of `should` conditions, including none of them. However, each `should` condition that a document matches increases its relevance score, so documents that match more `should` conditions are ranked higher in the results.

This makes `.should` useful for conditions that should increase the relevance of documents, but should not exclude documents that don't meet them. For example, you might use `.should` to give a higher ranking to documents that contain certain keywords or that were published recently.

Here's an example of how you might use the `.should` method:
```ruby
Model.should(title: 'Important').should(published_at: { gte: '2022-01-01' })
```
In this example, the `.should` method is used to increase the relevance of documents where the `title` field contains 'Important' and where the `published_at` field is on or after '2022-01-01'. Documents that don't meet these conditions are still included in the results, but they are ranked lower.

The `.should` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.

### Negation
The `.where_not` (aliased as `.must_not`) method is used to add conditions to the `must_not` clause of the query. This is different from the `.where` and `.filter_query` methods, which add conditions to the `must` and `filter` clauses, respectively.

Conditions in the `must_not` clause are used to exclude documents from the results. A document will be excluded if it matches any of the `must_not` conditions. This makes `.where_not` (or `.must_not`) useful for conditions that should exclude documents from the results.

Here's an example of how you might use the `.where_not` (or `.must_not`) method:

```ruby
Model.where_not(status: 'deleted')
```
In this example, the `.where_not` method is used to exclude documents where the `status` field is 'deleted'. Documents that meet this condition are not included in the results, regardless of whether they match any other conditions.

The `.where_not` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.

## Filter Query

The `.filter_query` method is used to add conditions to the filter clause of the query. This is similar to the .where method, but with an important difference: while the .where method affects both the matching of documents and the calculation of relevance scores, the `.filter_query` method only affects matching and does not affect scoring.

This makes `.filter_query` useful for conditions that should exclude documents from the results, but should not affect how the remaining documents are ranked. For example, you might use `.filter_query` to exclude documents that are marked as 'deleted' or that fall outside a certain date range.

In this example, the `.filter_query` method is used to exclude documents where the `deleted` field is `true` and where the `published_at` field is before '2022-01-01'. The remaining documents are ranked based on their relevance to the query, without considering the `deleted` and `published_at` fields.

```ruby
Model.filter_query(:term, deleted: false, color: 'green')
```


In this example, the `.filter_query` is used to generate a `range` filter and include documents where `author.age` is between 18 and 30.
```ruby
Model.filter_query(:range, 'author.age': {gte: 18, lte: 30})
```


The `.filter_query` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.

## Sorting

Sorting in Stretchy is done using the `.order` (aliased as `.sort`) method. This method allows you to specify one or more fields to sort the search results by. You can also specify the sort order for each field: ascending (`asc`) or descending (`desc`).

Here's an example of how you might use the `.order` method:
`.order` 

```ruby
Model.order(title: 'asc')
```

In this example, the search results will be sorted by the `title` field in ascending order. Documents with a lower `title` value will appear before documents with a higher `title` value.

You can also sort by multiple fields. For example:

```ruby
Model.order(title: 'asc', published_at: 'desc')
```

In this example, the search results will first be sorted by the `title` field in ascending order. If two documents have the same `title`, they will be sorted by the `published_at` field in descending order. This means that among the documents with the same title, the ones that were published more recently will appear first.

### Sorting Defaults
In Stretchy, the default_sort_key is the field that is used for sorting when no other sort order is specified. By default, this is set to `:created_at`, which means that if you don't specify a sort order, the search results will be sorted by the `created_at` field.

You can change the `default_sort_key` for a model by using the `default_sort_key` class method in your model definition. Here's an example:

```ruby
class Model < StretchyModel
  default_sort_key :new_sort_field
end
```
In this example, the `default_sort_key` for the `Model` class is set to `:new_sort_field`. This means that if you don't specify a sort order when querying the `Model` class, the search results will be sorted by the `new_sort_field` field.

Please note that you should replace `Model` with the name of your actual model, and `new_sort_field` with the name of the field that you want to use as the default sort key.

## Query String

The .query_string method is used to add a query string to the search. This method allows you to use Elasticsearch's [Query String syntax](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-query-string-query.html#query-string-syntax) to define complex search conditions.

The Query String syntax includes a series of terms and operators. Terms can be single words or phrases. Operators include `AND`, `OR`, and `NOT`, among others. Field names can be included in the query string to search for specific values in specific fields. For example, `"eye_color: green"` will match documents where the `eye_color` field is 'green'. The default operator between terms is OR.

Here's an example of how you might use the `.query_string` method:

```ruby
Model.query_string("((big cat) OR (domestic cat)) AND NOT panther eye_color: green")
```

In this example, the search results will include documents that match the query string. This means that they must either contain the phrase 'big cat' or the phrase 'domestic cat', they must not contain the word 'panther', and they must have 'green' as the value of the `eye_color` field.

The `.query_string` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.

### Changing the Default Operator

By default, the operator between terms in the query string is `OR`. This means that if a document matches any of the terms, it will be included in the search results. If you want to change this so that a document must match all of the terms to be included in the search results, you can set the `default_operator` option to `"AND"`.

Here's an example:

```ruby
Model.search_options(default_operator: "AND").query_string("(big cat) (domestic cat)")
```
In this example, the search results will include only documents that contain both 'big cat' and 'domestic cat'. If a document contains only one of these phrases, it will not be included in the search results.

## Highlighting

The `.highlight` method is used to highlight search matches in the fields of the returned documents. This can be useful to show where the search terms appear in the results.

The `.highlight` method accepts a list of field names to highlight. When a field is highlighted, Elasticsearch will return the original field value with the matching search terms wrapped in `<em> ` tags.

Here's an example of how you might use the `.highlight` method:

```ruby
Model.query_string("big cat").highlight(:title, :description)
```

In this example, the search results will include documents that contain 'big cat' in either the `title` or `description` field. The matching phrases in these fields will be highlighted.

The `.highlight` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.

Please note that highlighting requires extra processing by Elasticsearch, so it can slow down your search queries. You should use it sparingly and only when necessary.

## Source Filtering
The `.source` method is used to control which fields of the source document are returned in the search results. This can be useful to reduce the amount of data that is returned, especially for large documents.

The `.source` method accepts a list of field names to include in the results. Only the specified fields will be returned.

Here's an example of how you might use the `.source` method:
```ruby
Model.source(:title, :description)
```

In this example, the search results will include only the `title` and `description` fields of the matching documents.

## Field Selection
The `.fields` method is similar to the `.source` method, but it allows you to retrieve fields that are not included in the source document. This can be useful to retrieve fields that are computed at query time, such as script fields or doc values fields.

The `.fields` method accepts a list of field names to retrieve.

Here's an example of how you might use the `.fields` method:

```ruby
Model.fields(:computed_field, :doc_values_field)
```
In this example, the search results will include the `computed_field` and `doc_values_field` fields of the matching documents, even if these fields are not included in the source document.

Both the `.source` and `.fields` methods return a new `Stretchy::Relation` object, so you can chain other methods onto them to further refine your search.

## Search Options

The `.search_options` method is used to specify options that control how the search is executed. These options are passed directly to Elasticsearch and can include any of the parameters that [Elasticsearch's Search API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-search.html#search-search-api-path-params) accepts.

Here's an example of how you might use the `.search_options` method:

```ruby
Model.search_options(routing: 'user1', preference: '_local')
```
In this example, the `routing` option is set to 'user1', which means that the search will be routed to the shard that contains documents with 'user1' as the routing value. The `preference` option is set to '_local', which means that the search will prefer to be executed on the local shard if possible.

The `.search_options` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.


### Routing

The `.routing` method is a convenient way to specify the routing value for your search queries. Routing in Elasticsearch is a mechanism to control which shard a document is indexed into. When executing a search query, if a routing value is provided, Elasticsearch will only search the shards that match the routing value. This can significantly speed up search performance by reducing the number of shards that need to be searched.

Here's an example of how you might use the `.routing` method:

```ruby
Model.routing('user1')
```

In this example, the search will be routed to the shard that contains documents with 'user1' as the routing value. This means that only the shard with 'user1' will be searched, which can make the search faster if there are many shards and only a few of them contain documents with 'user1'.

The `.routing` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search.

### Query Safety 

Stretchy provides a mechanism to add requirements for queries that act as a circuit breaker. This can be helpful in preventing rogue queries that could potentially harm the performance of your Elasticsearch cluster.

The `query_must_have` method is used to specify these requirements. This method takes three arguments:

* The first argument is the name of the requirement.
* The second argument is the location where the requirement should be checked. This can be `:search_option`, `:query`, `:filter`, or `:must_not`.
* The third argument is a Proc that is used to validate the requirement. This Proc takes two arguments: the options that were passed to the search method, and the values that were passed to the `query_must_have` method. The Proc should return true if the requirement is met, and false otherwise.
Here's an example of how you might use the `query_must_have` method:

```ruby
class Model < Stretchy::Model
  query_must_have :routing, in: :search_option, validate_with: Proc.new { |options, values| options.include? :routing }
end
```

In this example, a requirement is added that the `:routing` option must be included in the search options. If a search is performed on the `Model` class without including the `:routing` option, an error will be raised.

This can be useful to ensure that all searches are routed to the correct shard, which can improve search performance. It can also help to prevent rogue queries that don't include the `:routing` option and could potentially search all shards, which could harm performance.

#### Skipping Callbacks
The `.skip_callbacks` method is used to skip the enforcement of certain `query_must_have` requirements for the immediate query. This can be useful in certain situations where you need to bypass the usual requirements, but it should be used with caution, as it can potentially lead to rogue queries.

The `.skip_callbacks` method accepts a list of requirement names to skip.

Here's an example of how you might use the `.skip_callbacks` method:

```ruby
Model.skip_callbacks(:routing).where(title: 'goats')
```
In this example, the `:routing` requirement is skipped for the immediate query. This means that even though the `Model` class has a `query_must_have` requirement for `:routing`, this requirement will not be enforced for this query. The query will be executed even if the `:routing` option is not included.

Please note that skipping callbacks can potentially harm performance and lead to unexpected results, so it should be used sparingly and only when necessary.

## Vector Search
>[!NOTE|style:flat|label:Compatability ]
> Some of these features only work with Opensearch 2.12+ or require an Elasticsearch license to access Machine Learning features.

Before using neural search, you must set up a [Machine Learning](guides/machine-learning?id=machine-learning) model. 


### neural
Neural search transforms text into vectors and facilitates vector search both at ingestion time and at search time. During ingestion, neural search transforms document text into vector embeddings and indexes both the text and its vector embeddings in a vector index. When you use a neural query during search, neural search converts the query text into vector embeddings, uses vector search to compare the query and document embeddings, and returns the closest results.

Before you ingest documents into an index, documents are passed through a machine learning (ML) model, which generates vector embeddings for the document fields. When you send a search request, the query text or image is also passed through the ML model, which generates the corresponding vector embeddings. Then neural search performs a vector search on the embeddings and returns matching documents.

```ruby
Model.neural(vector_embedding: "soft cats", k: 5)
```

##### Multimodal

By supplying a hash with `query_image` and/or `query_text` to the embedding field you can perform multimodal neural search:

```ruby
Model.neural(vector_embedding: {
	query_text: 'Leather coat',
	query_image: "iDs0djslsdSUAfx11..."
}, k: 5)
```
### neural_sparse

```ruby
Model.neural_sparse(body_embedding: "A funny thing about...")
```

### hybrid

Hybrid search combines keyword and neural search to improve search relevance. To implement hybrid search, you need to set up a search pipeline that runs at search time. 

```ruby
Modeo.hybrid(neural: [
    {passage_embedding: 'really soft cats', model_id: '1234', k: 2}
  ], 
  query: [
    {term: {status: :active}}
  ]
)
```