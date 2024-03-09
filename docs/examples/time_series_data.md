# Time Series Data with Rails, Stretchy and Elasticsearch

This guide will walk you through setting up a basic Rails application using Stretchy and Elasticsearch to ingest and visualize time series data.

## Prerequisites

- Ruby and Rails installed on your machine
- Elasticsearch installed and running

## Step 1: Create a New Rails Application

```terminal
rails new time_series_app
cd time_series_app
```

## Step 2: Add `stretchy-model` to Your Gemfile
```terminal
bundle add stretchy-model   
```
## Step 3: Configure Stretchy
#### Add credentials
```terminal
rails credentials:edit
```

```yaml
elasticsearch:
   url: localhost:9200

# or opensearch
# opensearch:
#    host: https://localhost:9200
#    user: admin
#    password: admin
#    transport_options:
#       ssl:
#         verify: false
```

> __NOTE__ If using Opensearch be sure to run:
> ```terminal
>   bundle add opensearch
> ```

Create an initializer file config/initializers/stretchy.rb and add the following:
```ruby
Stretchy.configure do |config|
    config.client = Elasticsearch::Client.new Rails.application.credentials.elasticsearch
    # or if using Opensearch
    # config.client = Openseaerch::Client.new Rails.application.credentials.opensearch
end
```

## Identify a Data Set

Let's use "Historical Plane Crashes Since 1908" for our dataset. The following will download the csv, transform the headers and output a json file. 

Open a Rails console:
```terminal
rails c
```

```ruby
require 'open-uri'
require 'csv'

url = 'https://huggingface.co/datasets/nateraw/airplane-crashes-and-fatalities/resolve/main/Airplane_Crashes_and_Fatalities_Since_1908.csv?download=true'
download = URI.open(url)
scrub_headers = lambda { |header| header.parameterize.underscore }
csv = CSV.parse(download.read, headers: true, header_converters: scrub_headers)
data = csv.map(&:to_hash)
data.each { |d| d.merge!({'occurred_on': "#{d.delete('date')} #{d.delete('time')}"}); d.delete('index') }

File.open('airplane_crashes.json', 'w') do |f|
  f.write(JSON.pretty_generate(data))
end
```

Now, each entry has the following schema:
```json
{
        "location": "Fort Myer, Virginia",
        "operator": "Military - U.S. Army",
          "flight": null,
           "route": "Demonstration",
            "type": "Wright Flyer III",
    "registration": null,
           "cn_in": "1",
          "aboard": "2.0",
      "fatalities": "1.0",
          "ground": "0.0",
         "summary": "During a demonstration flight, a U.S. Army flyer flown by Orville Wright nose-dived into the ground from a height of approximately 75 feet, killing Lt. Thomas E. Selfridge who was a passenger. This was the first recorded airplane fatality in history.  One of two propellers separated in flight, tearing loose the wires bracing the rudder and causing the loss of control of the aircraft.  Orville Wright suffered broken ribs, pelvis and a leg.  Selfridge suffered a crushed skull and died a short time later.",
      "occured_on": "09/17/1908 17:18"
}
```

## Understanding Performance Benefits
## Define a Index Strategy

Since we have a date field, we can store this data across multiple indexes. `stretchy-model` makes it easy to facilitate this strategy, which is useful when you have a rolling window of data. 

## Determine Routing Strategy

Routing determines which shard in the cluster the document will be written routed to. For large data sets it's a good idea to choose a routing key that groups similar queried data together. It all depends on your needs and your data distribution. For example purposes we'll route based on the operator.

## Define CrashEvent Model
Create a file for `CrashEvent` at `app/models/crash_event.rb`

```ruby
class CrashEvent < Stretchy::Record

  attribute :occurred_on, :datetime
  attribute :location, :string
  attribute :operator, :string
  attribute :flight, :string
  attribute :route, :string
  attribute :type, :string
  attribute :registration, :string
  attribute :cn_in, :string
  attribute :aboard, :float
  attribute :fatalities, :float
  attribute :ground, :float
  attribute :summary, :string

  scope :operator_fatalities, -> { aggregation(:operator_fatalities, 
      {
        terms: {
          field: :operator
        }, 
        aggs: {
          fatalities: {
            sum: {
              field: :fatalities
            }
          }
        }
      }
    ) 
  }

  scope :date_histogram, ->(name, options, *aggs) do
    # requires field and calendar_interval or interval
    aggregation(name, {date_histogram: options}.merge(*aggs))
  end

end

```


## Bulk Index Documents


Reload your Rails console and start the bulk index operation:

```ruby
data = JSON.parse(File.read('airplane_crashes.json'))
CrashEvent.bulk_in_batches(data, size: 100) do |batch|
    puts "Processing batch: #{batch.length}"
    batch.map! do |event|
      CrashEvent.new(event.symbolize_keys).to_bulk
    end
end
```

You should see a response showing that each batch was indexed successfully and we should have entries in Elasticsearch!

```ruby
CrashEvent.count
#=> 5268
```

Let's use our scope to apply the aggregation and set size to 0 since we're only performing aggregations and don't want any document source
```ruby
response = CrashEvent.operator_fatalities.size(0)
ap response.aggregations.operator_fatalities.buckets
```

```ruby
=> [
  {
    "key"        => "Aeroflot",
    "doc_count"  => 179,
    "fatalities" => {
      "value" => 7156.0
    }
  },
  {
    "key"        => "Military - U.S. Air Force",
    "doc_count"  => 176,
    "fatalities" => {
      "value" => 3717.0
    }
  },
  {
    "key"        => "Air France",
    "doc_count"  => 70,
    "fatalities" => {
      "value" => 1734.0
    }
  },
  ...
]
```


## Visualization
### (Bonus) show associations with ActiveRecord