[![Ruby CI](https://github.com/theablefew/stretchy/actions/workflows/spec.yml/badge.svg)](https://github.com/theablefew/stretchy/actions/workflows/spec.yml)

# stretchy

Stretchy provides a seamless ActiveRecord-like interface for interacting with Elasticsearch models in a Rails environment. It simplifies the process of querying, aggregating, and managing Elasticsearch-backed models, allowing Rails developers to work with search indices as comfortably as they would with traditional relational databases.

### Features:

__Query Interface:__ Stretchy introduces familiar ActiveRecord query methods such as .where, .where_not, .first, .last, .count, and more, tailored for Elasticsearch. This makes querying intuitive for Rails developers, enabling complex search queries through a simple and familiar syntax.

__Chaining:__ Queries can be chained to refine searches with multiple conditions, mimicking ActiveRecord's ability to build up queries through method chaining. This includes combining filters, must/must_not conditions, and sorting.

__Aggregations__: Stretchy supports Elasticsearch's powerful aggregation framework, allowing for complex data summarization and analytics. It provides a straightforward way to define and access aggregations, such as terms and nested aggregations, directly from the model.

__Scopes:__ Like ActiveRecord, Stretchy allows the definition of custom scopes for reusing common query patterns. This feature encourages clean, modular code by encapsulating frequently used queries into callable methods.

__Magic Fields and Defaults:__ Stretchy automatically handles created_at and updated_at timestamps and allows setting default sort keys and index names based on the class name or a custom value. It also supports attribute definitions with types and defaults, enhancing model structure and integrity.

__Bulk Operations:__ For efficient data manipulation, Stretchy includes support for bulk indexing, deletion, and updates. This is essential for managing large datasets or performing batch operations efficiently.

__Instrumentation:__ Leveraging ActiveSupport::Instrumentation, Stretchy logs queries for performance monitoring and debugging, providing insights into Elasticsearch interactions.


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add stretchy

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install stretchy

## Usage

### where(field: value)

```ruby
Model.where(color: :red)
# query => {"query":{"bool":{"must":{"term":{"color":"red"}}}}}
```

### not(field: value)
```ruby
Model.where_not(color: :red)
# query => {"query":{"bool":{"must_not":{"term":{"color":"red"}}}}}
```

### first
```ruby
Model.first
# query => {"sort":{"created_at":"asc"}}
```

### last
```ruby
Model.last
# query => {"sort":{"created_at":"desc"}}
```
### count

```ruby
Model.where(color: :blue).count
#=> 60

Model.count
#=> {"count"=>624, "_shards"=>{"total"=>5, "successful"=>5, "skipped"=>0, "failed"=>0}}
```

### source(include: [...fields...])

```ruby
Model.source(include: [:body, :color])
```

### filter(:filter_method, arguments)

```ruby
Model.filter(:terms, color: [:blue, :red])
# query => {"query":{"bool":{"filter":{"bool":{"must":[{"terms":{"color":["blue","red"]}}]}}}}}
```

```ruby
Model.filter(:term, color: :red)
# query => {"query":{"bool":{"filter":{"bool":{"must":[{"term":{"color":"red"}}]}}}}}
```

### size

```ruby
Model.size(10000)
```



### routing(:field_name)

```ruby
Model.routing(:id)
# query => models/_search?routing=id&size=10000
```

### Chaining

```ruby
Model.where_not(color: :red).where(in_stock: true)
# query => {"query":{"bool":{"must":{"term":{"in_stock":true}},"must_not":{"term":{"color":"red"}}}}}
```

```ruby
Model.where_not(color: :red).where(in_stock: true, local: true).filter(:term, soft: true)
# query => {"query":{"bool":{"must":[{"term":{"in_stock":true}},{"term":{"local":true}}],"must_not":{"term":{"color":"red"}},"filter":{"bool":{"must":[{"term":{"soft":true}}]}}}}}
```

## Aggregations


aggregation `:bucket_name`, `aggregation_type:` { `args...` } 


### Terms
```ruby
aggregation(:colors, terms: {field: :color})
```

### Nested
```ruby
aggregation(:colors, 
    terms: {
      field: :color
    }, 
    aggs: { 
      total: { 
        sum: {
          field: :price
        } 
      }
    }
)
```

Aggregations are accessible on the result object. 

```ruby
result = Model.filter(:terms, color: :blue).aggregation(:totals, sum: {field: :quantity})
result.aggregations.totals #=> 10
```



## Scopes
```ruby

  scope :colored, ->(colors) { aggregation(:colors, filters: { colors: { terms: { color: colors} } ) }
  scope :available, -> { where(available: true) }
  scope :between, lambda { |range| filter(:range, date: {gte: range.begin, lte: range.end}) }
```

## Associations




## Magic Fields
(:created_at, :updated_at)

### Default Sort
```ruby
default_sort_key :created_at
```

### Index name
Automatically derived from class name as `ClassName.to_s.tableize`

```ruby
index_name 'items'
```


## Attributes

```ruby
attribute :color,       String,     default: :blue, index: 'not_analyzed'
attribute :guid,        Keyword
attribute :sizes,       Array,      default: [], index: :not_analyzed
attribute :available,   Boolean,    default: false
attribute :quantity,    Integer,    default: 0
attribute :date         DateTime
```

## Relation

## Bulk Operations
```ruby
to_bulk(:index) # default
to_bulk(:delete)
to_bulk(:update)
```

```ruby
blankets = [{"color": "blue", "quantity": 100}, ...]
```

```ruby
blankets.each_slice(100) do |batch|
    blankets_batch = batch.collect do |item|
      Blanket.new( color: item.color, quantity: item.quantity).to_bulk
    end
    Blanket.gateway.client.bulk body: blankets_batch
end
```


## Instrumentation
Queries are automatically logged via ActiveSupport::Instrumentation via the `to_elastic` method.
```ruby
Blanket (6.322ms) curl -X GET 'http://localhost:9200/blankets/_search?size=1' -d '{"sort":{"date":"desc"}}'
```

```ruby
Model.to_elastic
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Testing
```
docker-compose up elasticsearch
```

```
docker-compose up opensearch
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/esmarkowski/stretchy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/esmarkowski/stretchy/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stretchy project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/esmarkowski/stretchy/blob/master/CODE_OF_CONDUCT.md).
