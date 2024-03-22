stretchy-model
===
Stretchy provides Elasticsearch/Opensearch models in Rails applications with an Rails-like model interface.
<p >
    <a href="https://github.com/theablefew/stretchy/releases"><img src="https://img.shields.io/github/v/release/theablefew/stretchy?sort=semver&color=blue"></a>
    <a href="https://github.com/theablefew/stretchy/actions"><img src="https://github.com/theablefew/stretchy/actions/workflows/spec.yml/badge.svg"></a>

</p>

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

Follow the guides to learn more about:
* [Models](guides/models?id=models)
* [Querying](guides/querying?id=querying)
* [Aggregations](guides/aggregations?id=aggregations)
* [Scopes](guides/scopes?id=scopes) 
* [Pipelines](guides/pipelines?id=pipelines)
* [Machine Learning](guides/machine-learning?id=machine-learning)

**Examples**
 - [Data Analysis](examples/data_analysis?id=data-analysis)
 - [Simple Ingest Pipeline](examples/simple-ingest-pipeline?id=simple-ingest-pipeline)


## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
bundle add stretchy-model
```

If bundler is not being used to manage dependencies, install the gem by executing:

```sh
gem install stretchy-model
```

>[!INFO|style:flat]
> If using OpenSearch add the gem to your Gemfile:
>
> ```
> bundle add opensearch-ruby
> ```

#### Add credentials

```sh
rails credentials:edit
```

```yaml
elasticsearch:
   url: localhost:9200

# or if using opensearch
# opensearch:
#    host: http://localhost:9200
#    user: admin
#    password: admin
#    transport_options:
#       ssl:
#         verify: false
```

#### Create an initializer 
*config/initializers/stretchy.rb*

```ruby
Stretchy.configure do |config|
    config.client = Elasticsearch::Client.new Rails.application.credentials.elasticsearch
    # or if using OpenSearch
    # config.client = OpenSearch::Client.new Rails.application.credentials.opensearch
end
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


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

