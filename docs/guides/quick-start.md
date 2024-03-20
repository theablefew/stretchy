# Quick Start

## Prerequisites

- Ruby and Rails installed on your machine

>[!TIP|style:flat]
> These docker commands will run a single-node cluster suitable for local development.
>
> Choose Elasticsearch or OpenSearch

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

> [!INFO|style:flat]
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