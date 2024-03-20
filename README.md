stretchy-model
===
<p>
    <a href="https://stretchy.io/" target="_blank"><img src="./stretchy.logo.png" alt="Stretchy Image" width="450" /></a>
    <br><br>
    <a href="https://github.com/theablefew/stretchy/releases"><img src="https://img.shields.io/github/v/release/theablefew/stretchy?sort=semver&color=blue"></a>
    <a href="https://github.com/theablefew/stretchy/actions"><img src="https://github.com/theablefew/stretchy/actions/workflows/spec.yml/badge.svg"></a>

</p>

<<<<<<< HEAD
Stretchy provides Elasticsearch/Opensearch models in Rails applications with an Rails-like model interface.
=======
>>>>>>> main

## Features
Stretchy simplifies the process of querying, aggregating, and managing Elasticsearch-backed models, allowing Rails developers to work with search indices as comfortably as they would with traditional Rails models.

* Models fully back by Elasticsearch/Opensearch
* Chain `queries`, `scopes` and `aggregations`
* Reduce Elasticsearch query complexity
* Support for time-based indices and aliases
* Associations to both ActiveRecord models and `StretchyModel`
* Bulk Operations made easy
* Ingest and Search Pipelines
* Machine Learning
* Vector and Neural search 
* Integrated RAG and LLM connectors
* Validations, custom attributes, and more...
<<<<<<< HEAD

## Models

### Attributes

```ruby
class Post < Stretchy::Record

    attribute :title,                   :string
    attribute :body,                    :string
    attribute :flagged,                 :boolean,  default: false  
    attribute :author,                  :hash 
    attribute :tags,                    :array, default: []

end
```
>[!NOTE]
>`created_at`, `:updated_at` and `:id` are automatically added to all `Stretchy::Records`
> 
> The `default_sort_key` is :created_at


### Query
```ruby
Post.where(title: :goat, flagged: false)
#=> <Post id: 309sXA2s, title: "goat", body: "...", flagged: false, author...>
```
Query object fields with dot notation
```ruby
  Post.where('author.name': "Jadzia", flagged: true).first
  #=> <Post id: aW02w3092, title: "Fun Cats", body: "...", flagged: true,
  #         author: {name: "Jadzia", age: 20}, tags: ["cat", "amusing"]>
```

### Aggregations
```ruby

  result = Post.aggregation(:post_frequency, 
    date_histogram: {
      field: :created_at,
      calender_interval: :month
    })

  result.aggregations.post_frequency
  #=> {buckets: [{key_as_string: "2024-01-01", doc_count: 20}, ...]}
```
### Filters

```ruby
Post.filter(:range, 'author.age': {gte: 18, lte: 30}).where(title: "Welcome")
#=> filters authors with age greater than 18 and less than 30
```

### Scopes
Scopes can contain any query methods, filters or aggregations, resulting in composable queries. 
```ruby
class Post < Stretchy::Record
  # ...attributes

  # Scopes
  scope :flagged, -> { where(flagged: true) }
  scope :top_links, lambda do |size=10, url=".com"| 
    aggregation(:links, 
      terms: {
        field: :links, 
        size: size, 
        include: ".*#{url}.*"
      })
  end
end
=======
>>>>>>> main

Follow the guides to learn more about:
* [Models](https://theablefew.github.io/stretchy/#/guides/models?id=models)
* [Querying](https://theablefew.github.io/stretchy/#/guides/querying?id=querying)
* [Aggregations](https://theablefew.github.io/stretchy/#/guides/aggregations?id=aggregations)
* [Scopes](https://theablefew.github.io/stretchy/#/guides/scopes?id=scopes)
* [Pipelines](https://theablefew.github.io/stretchy/#/guides/pipelines?id=pipelines)
* [Machine Learning](https://theablefew.github.io/stretchy/#/guides/machine-learning?id=machine-learning)

[Read the Documentation](https://theablefew.github.io/stretchy/#/) or follow the examples below:

 **Examples**
 - [Data Analysis](https://theablefew.github.io/stretchy/#/examples/data_analysis?id=data-analysis) example.
 - [Simple Ingest Pipeline](https://theablefew.github.io/stretchy/#/examples/simple-ingest-pipeline?id=simple-ingest-pipeline)



## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
 bundle add stretchy-model
```

If bundler is not being used to manage dependencies, install the gem by executing:
```sh
  gem install stretchy-model
```

>[!TIP]
> If using OpenSearch make sure to add the gem to your Gemfile.
>
> `bundle add opensearch-ruby`

<details>
<summary>Rails Configuration</summary>


```sh
rails credentials:edit
```

#### Add elasticsearch credentials
```yaml
elasticsearch:
   url: localhost:9200

# or if using opensearch
# opensearch:
#    host: https://localhost:9200
#    user: admin
#    password: admin
#    transport_options:
#       ssl:
#         verify: false
```

#### Create an initializer 
<p><sub><em>config/initializers/stretchy.rb</em></sub></p>

```ruby
Stretchy.configure do |config|
    config.client = Elasticsearch::Client.new Rails.application.credentials.elasticsearch
    # or if using OpenSearch
    # config.client = OpenSearch::Client.new Rails.application.credentials.opensearch
end
```
</details>


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

>[!TIP]
> Full documentation on [Elasticsearch Query DSL and Aggregation options](https://github.com/elastic/elasticsearch-rails/tree/main/elasticsearch-persistence)

## Testing
<details>
<summary>Act</summary>

Run github action workflow locally

```sh
brew install act --HEAD
```

```sh
act -P ubuntu-latest=ghcr.io/catthehacker/ubuntu:runner-latest
```

</details>

<details>
<summary>Elasticsearch</summary>


```
docker-compose up elasticsearch
```

```
bundle exec rspec
```

</details>

<details>
<summary>Opensearch</summary>


```
docker-compose up opensearch
```

```
ENV['BACKEND']=opensearch bundle rspec 
```
</details>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/theablefew/stretchy. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/theablefew/stretchy/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

