stretchy-model
===

<p>
    <a href="https://stretchy.io/" target="_blank"><img src="./stretchy.logo.png" alt="Gum Image" width="450" /></a>
    <br><br>
    <a href="https://github.com/theablefew/stretchy/releases"><img src="https://img.shields.io/github/v/release/theablefew/stretchy?sort=semver&color=blue"></a>
    <a href="https://github.com/theablefew/stretchy/actions"><img src="https://github.com/theablefew/stretchy/actions/workflows/spec.yml/badge.svg"></a>

</p>

Stretchy provides Elasticsearch models in a Rails environment with an integrated ActiveRecord-like interface and features. 

## Features
Stretchy simplifies the process of querying, aggregating, and managing Elasticsearch-backed models, allowing Rails developers to work with search indices as comfortably as they would with traditional Rails models.

## Attributes

```ruby
class Post < Stretchy::Record

    attribute :title,                   :string
    attribute :body,                    :string
    attribute :flagged,                 :boolean,  default: false  
    attribute :author,                   :hash 
    attribute :tags,                    :array, default: []

end
```
>[!NOTE]
>`created_at`, `:updated_at` and `:id` are automatically added to all `Stretchy::Records`


## Query
```ruby
  Post.where('author.name': "Jadzia", flagged: true).first
  #=> <Post id: aW02w3092, title: "Fun Cats", body: "...", flagged: true,
  #         author: {name: "Jadzia", age: 20}, tags: ["cat", "amusing"]>
```

## Aggregations
```ruby

  result = Post.filter(:range, 'author.age': {gte: 18})
    .aggregation(:post_frequency, date_histogram: {
      field: :created_at,
      calender_interval: :month
    })

  result.aggregations.post_frequency
  #=> {buckets: [{key_as_string: "2024-01-01", doc_count: 20}, ...]}
```

## Scopes

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

# Returns flagged posts and includes the top 10 'youtube.com' 
# links in results.aggregations.links
result = Post.flagged.top_links(10, "youtube.com")

```

## Bulk Operations


```ruby
Model.bulk(records_as_bulk_operations)
```

#### Bulk helper
Generates structure for the bulk operation
```ruby
record.to_bulk # default to_bulk(:index)
record.to_bulk(:delete)
record.to_bulk(:update)
```

#### In batches
Run bulk operations in batches specified by `size`
```ruby
Model.bulk_in_batches(records, size: 100) do |batch|
    batch.map! { |record| Model.new(record).to_bulk }
end
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add stretchy-model

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install stretchy-model

<details>
<summary>Rails Configuration</summary>



```sh
rails credentials:edit
```

#### Add elasticsearch credentials
```yaml
elasticsearch:
   url: localhost:9200

# or opensearch
# opensearch:
#    host: https://localhost:9200
#    user: admin
#    password: admin
```

#### Create an initializer 
<p><sub><em>config/initializers/stretchy.rb</em></sub></p>

```ruby {file=config/initializers/stretchy.rb}
Stretchy.configure do |config|
    config.client = Elasticsearch::Client.new url: Rails.application.credentials.elasticsearch.url, log: true
end
```
</details>


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

>[!TIP]
>This library is built on top of the excellent [elasticsearch-persistence](https://github.com/elastic/elasticsearch-rails/tree/main/elasticsearch-persistence) gem. 
>
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

