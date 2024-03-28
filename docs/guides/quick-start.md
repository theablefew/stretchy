# Quick Start

## Prerequisites

- Ruby and Rails installed on your machine

>[!TIP|style:flat|label:Single Node Clusters]
> These docker commands will run a single-node cluster suitable for local development.


#### Choose Elasticsearch or OpenSearch

__Start Elasticsearch:__

```sh
docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:8.12.0
```
__Start Opensearch:__
```sh
docker run -d -p 9200:9200 -e "discovery.type=single-node" opensearchproject/opensearch:2.12.0
```

## Create a New Rails Application

```sh
rails new fantastic_thing
cd fantastic_thing
```

## Add stretchy-model
```sh
bundle add stretchy-model   
```

> [!INFO|style:flat|label:OpenSearch]
> If using Opensearch be sure to add it to your Gemfile:
>
```sh
bundle add opensearch-ruby
```

## Configure Stretchy
#### Add credentials
```sh
rails credentials:edit
```

```yaml
elasticsearch:
   url: localhost:9200

# if using opensearch
# opensearch:
#    host: https://localhost:9200
#    user: admin
#    password: admin
#    transport_options:
#       ssl:
#         verify: false
```


#### Add an initializer

Create an initializer file *config/initializers/stretchy.rb* and add the following:
```ruby
Stretchy.configure do |config|
    config.client = Elasticsearch::Client.new Rails.application.credentials.elasticsearch
    # or if using Opensearch
    # config.client = Openseaerch::Client.new Rails.application.credentials.opensearch
end
```

#### Create a model

```ruby
class Product < StretchyModel
    attribute :price, :integer
    attribute :upc, :keyword
    attribute :color, :keyword
end
```

#### Managing Models, Pipelines and Machine Learning Models

Stretchy has a suite of rake tasks built in to make working with Elasticsearch and OpenSearch easier.

```sh
rake stretchy:index:create              # Create indices
rake stretchy:index:delete              # Delete indices
rake stretchy:index:status              # Check the status of all indexes
rake stretchy:ml:delete                 # Delete the model ENV['MODEL']
rake stretchy:ml:deploy                 # Deploy the model ENV['MODEL']
rake stretchy:ml:register               # Register the model ENV['MODEL']
rake stretchy:ml:status                 # Check the status of all pipelines
rake stretchy:ml:undeploy               # Undeploy the model ENV['MODEL']
rake stretchy:pipeline:create           # Create pipeline
rake stretchy:pipeline:delete           # Delete pipeline
rake stretchy:pipeline:status           # Check the status of all pipelines
rake stretchy:status                    # Check the status of all indexes, pipelines and ml models
rake stretchy:status:all                # Check the status of all indexes
rake stretchy:up                        # Create all indexes, pipelines and deploy all models
rake stretchy:down                      # Delete all indexes, pipelines and undeploy all models
```


![rake](../media/stretchy_up.mov)

Run `rake:stretchy:up` to create all Machine Learning models, Pipelines and Indices. 