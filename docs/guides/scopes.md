# Scopes

In Stretchy, `scope` is a method that allows you to define commonly used queries that can be referenced as method calls on the model. Scopes are a way to encapsulate complex queries into simple, meaningful methods. This can make your code more maintainable and your queries more readable.

Here's an example of how you might define a scope:

```ruby
class Model < StretchyModel
  scope :published, -> { where(published: true) }
end
```

In this example, a scope named `published` is defined. This scope includes all documents where the `published` field is `true`.

You can use this scope in your queries like this:

```ruby
Model.published
```

This will return all published documents.

Scopes are chainable, meaning you can use multiple scopes in a single query:

```ruby
Model.published.recent
```

In this example, the `published` and `recent` scopes are used together. This will return all documents that are both published and recent.

Scopes can also take arguments, allowing you to create more dynamic queries:

```ruby
class Model < Stretchy::Model
  scope :with_title, ->(title) { where(title: title) }
end
```

In this example, the `with_title` scope takes a `title` argument and includes all documents where the `title` field matches the given title. You can use this scope like this:

```ruby
Model.with_title('My Title')
```

This will return all documents with the title 'My Title'.

### With Aggregations

Using scopes with aggregations is a powerful way to add complex aggregations and use them throughout your code.

Aggregations in Elasticsearch provide a way to group and summarize your data in various ways, such as counting the number of documents that match certain criteria, calculating averages, sums, or other statistics, creating histograms or other types of data visualizations, and more.

Here's an example of how you might define a scope that includes an aggregation:

```ruby
class Model < StretchyModel
  scope :published, -> { where(published: true) }
  scope :average_rating_agg, -> { aggregation(:average_rating, avg: { field: :rating }) }
end
```

> _Implementing a naming convention for aggregation scopes can help make your code more readable and maintainable. By appending `_agg` to the name of aggregation scopes, you can easily distinguish them from other scopes._

In this example, a scope named `average_rating_agg` is defined. This scope includes an aggregation that calculates the average value of the `rating` field.

You can use this scope in your queries like this:

```ruby
Model.published.average_rating_agg
```

This will return the average rating of published documents.

Just like other scopes, aggregation scopes are chainable and can take arguments, allowing you to create dynamic aggregation queries. For example, you could define a scope that calculates the average rating for a specific category:

```ruby
class Model < StretchyModel
  scope :average_rating_agg_for, ->(category) { 
    where(category: category).aggregation(:average_rating, avg: { field: :rating }) 
  }
end
```

You can use this scope like this:

```ruby
Model.average_rating_agg_for('Books')
```

This will return the average rating of all documents in the 'Books' category.

### Shared Scopes

Stretchy has built-in shared scopes available to all StretchyModel models.

#### Between Scope
The `between` scope is used to filter documents based on a range of values in a specific field. By default, this field is created_at, but you can specify a different field if needed.

Here's an example of how you might use the `between` scope:
```ruby
Model.between(1.day.ago..Time.now)
```

In this example, the search results will include only documents that were created in the last day.

Here's how to specify a different field:
```ruby
Model.between(15..20, :price)
```

This will return documents with a price between 15 and 20.

#### Using Time-Based Indices Scope
The `using_time_based_indices` scope is used to search across multiple indices based on a time range. This can significantly reduce the load on the Elasticsearch cluster when there are many indices for a given model.

Here's an example of how you might use the `using_time_based_indices` scope:

```ruby
Model.using_time_based_indices(2.months.ago..1.day.ago)
```

In this example, the search will be performed across all indices for the Model class that were created in the last two months.

These scopes are available to all `StretchyModel` models, making it easy to perform common types of queries.