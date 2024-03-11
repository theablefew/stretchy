stretchy-model
===
Stretchy provides Elasticsearch/Opensearch models in Rails applications with an Rails-like model interface.
<p >
    <a href="https://github.com/theablefew/stretchy/releases"><img src="https://img.shields.io/github/v/release/theablefew/stretchy?sort=semver&color=blue"></a>
    <a href="https://github.com/theablefew/stretchy/actions"><img src="https://github.com/theablefew/stretchy/actions/workflows/spec.yml/badge.svg"></a>

</p>

## Features
Stretchy simplifies the process of querying, aggregating, and managing Elasticsearch-backed models, allowing Rails developers to work with search indices as comfortably as they would with traditional Rails models.

* Model fully back by Elasticsearch/Opensearch
* Chain `queries`, `scopes` and `aggregations`
* Reduce Elasticsearch query complexity
* Support for time-based indices and aliases
* Associations to both ActiveRecord models and `Stretchy::Record`
* Bulk Operations made easy
* Validations, custom attributes, and more...

Follow the guides to learn more about:
* [Models](guides/models?id=models)
* [Querying](guides/querying?id=querying)
* [Aggregations](guides/aggregations?id=aggregations)
* [Scopes](guides/scopes?id=scopes) 

or walk through of a simple [Data Analysis](examples/data_analysis?id=data-analysis) example.

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add stretchy-model
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install stretchy-model
```

<details>
<summary><strong>Rails Configuration</strong></summary>



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

