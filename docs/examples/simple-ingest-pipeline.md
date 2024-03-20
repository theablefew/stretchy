# Simple Ingest Pipeline

**Prerequisites:**

- Opensearch installed and running
- Ruby on Rails or stretchy-model's `bin/console`

Follow the [Quick Start](guides/quick-start) for detailed steps. 

## Data Source

Our data source is a JSON data representing vitals and patient information scraped from the dark web (jk). We have an id, vitals as a CSV, full name, age and a SSN with HTML tags. What a mess!


| id      | vitals     | name                       | age | ssn                |
| ------- | ---------- | -------------------------- | --- | ------------------ |
| ta0j288 | 700,120,72 | Gov. Candy Williams        | 30  | <b>547-93-4227</b> |
| ta0j288 | 56,120,72  | Romana Prohaska            | 30  | <b>547-93-4227</b> |
| pnunl70 | 114,136,43 | Tristan Waelchi            | 81  | <b>323-23-5997</b> |
| 8lhscax | 105,66,56  | Antoine Hauck              | 46  | <b>381-54-5352</b> |
| impcbo9 | 119,78,60  | Dewayne Stark              | 39  | <b>816-86-6698</b> |
| jxr8h3v | 81,69,58   | Shelton Powlowski          | 77  | <b>810-63-7478</b> |
| d7lwaln | 103,140,93 | Sage Medhurst              | 19  | <b>470-43-3841</b> |
| ryrtjb5 | 57,118,86  | Tobias Strosin             | 76  | <b>197-25-4397</b> |
| ox227l3 | 82,103,98  | Jessi Barton               | 41  | <b>700-41-0042</b> |
| c7vyqu2 | 103,73,90  | Eliseo Feest               | 53  | <b>153-01-6678</b> |
| i8lbviz | 81,120,91  | The Hon. Zandra Dibbert MD | 55  | <b>881-10-7835</b> |

Our goal is to create an ingest pipeline using `stretchy-model` to process this data. The pipeline will transform the vitals from a CSV into an array, remove the HTML tags from the SSN, and split the full name into first and last names.

## Define the Pipeline

An ingest pipeline in Elasticsearch allows us to pre-process documents before the actual document indexing occurs. It's a way to transform and enrich the data, making it more useful and easier to work with.

```mermaid
flowchart LR

CSV --> SCRIPT

SCRIPT --> HTML_STRIP

HTML_STRIP --> CONVERT

CONVERT --> REMOVE

REMOVE --> INDEX

```
By doing these transformations as part of the ingest process, we ensure that the data is in the right format and structure for our needs right from the moment it enters Elasticsearch. This makes our subsequent data handling and analysis tasks much easier and more efficient.

```ruby
class IntakeFormPipeline < Stretchy::Pipeline

	description "Ingests intake forms and scrubs ssn of html"
	  
	processor :csv, 
		field: :vitals, 
		target_fields: [:heart_rate, :systolic, :diastolic],
		trim: true
		
	processor :script, 
		description: "Extracts first and last name from name field",
		lang: "painless",
		source: <<~PAINLESS
			ctx['name'] = /^[\\w\\s]+\\.\\s/.matcher(ctx['name']).replaceAll("");
			String[] parts = /\\s+/.split(ctx['name']);
			ctx['first_name'] = parts[0];
			if (parts.length > 1) {
			  ctx['last_name'] = parts[1];
			}
		PAINLESS
		
	processor :html_strip, field: :ssn
	processor :convert, field: :systolic, type: :integer
	processor :convert, field: :diastolic, type: :integer
	processor :convert, field: :heart_rate, type: :integer
 
	processor :remove, field: :name
	processor :remove, field: :vitals
    
end
```

The `IntakeFormPipeline` will preprocess documents that are sent to be indexed. We have a `description` and a series of `processor` statements, each performing a specific transformation on the data:

- **csv** - parse `vitals` and map them to `heart_rate`, `systolic` and `diastolic` fields
- **script** - split `name` into `first_name` and `last_name`, removing any titles like Dr., Rev. etc. 
- **html_strip** - scrub `ssn` of any HTML tags
- **convert** - ensure vitals are all integers
- **remove** - remove the fields we no longer need

**Create the pipeline:**

This command sends a request to the Elasticsearch server to create a new ingest pipeline with the specifications defined in the IntakeFormPipeline class.

Once the pipeline is created, it's ready to preprocess any documents that are sent to be indexed. The transformations defined in the pipeline (such as parsing CSVs, splitting names, stripping HTML tags, and converting fields to integers) will be applied to each document before it's indexed.

```ruby
IntakeFormPipeline.create!
```

Remember, the pipeline only needs to be created once. After it's created, it will be used automatically whenever documents are indexed in Elasticsearch. If you need to change the pipeline, you can remove it with the `IntakeFormPipeline.delete! command.

## Describe the Model

The `IntakeForm` model represents the index were we’ll store our intake forms. 

```ruby
class IntakeForm < StretchyModel
  attribute :first_name, :keyword
  attribute :last_name, :keyword
  attribute :ssn, :keyword
  attribute :age, :integer
  attribute :heart_rate, :integer
  attribute :systolic, :integer
  attribute :diastolic, :integer

  default_pipeline :intake_form_pipeline
end
```
The IntakeForm model inherits from `StretchyModel`, which means it gets all the functionality provided by `StretchyModel`.

The `attribute` method is used to define the fields of the IntakeForm model. Each `attribute` has a name and a type. The type corresponds to the Elasticsearch field type.

The `default_pipeline` method sets the default ingest pipeline for the model. In this case, it's set to `:intake_form_pipeline`, which means that the intake_form_pipeline will be used to preprocess documents before they are indexed.


**Create the index:**

```ruby
IntakeForm.create_index!
```

## Run the pipeline

To run the pipeline, you'll need to index documents using the `IntakeForm` model. The `default_pipeline` you set earlier will automatically preprocess the documents before they are indexed.

```ruby
initial_data = [
    {"id": "ta0j288", "vitals": "700,120,72", "name": "Gov. Candy Williams", "age": 30, "ssn": "<b>547-93-4227</b>"},
    {"id": "ta0j288", "vitals": "56,120,72", "name": "Romana Prohaska", "age": 30, "ssn": "<b>547-93-4227</b>"},
    {"id": "pnunl70", "vitals": "114,136,43", "name": "Tristan Waelchi", "age": 81, "ssn": "<b>323-23-5997</b>"},
    {"id": "8lhscax", "vitals": "105,66,56", "name": "Antoine Hauck", "age": 46, "ssn": "<b>381-54-5352</b>"},
    {"id": "impcbo9", "vitals": "119,78,60", "name": "Dewayne Stark", "age": 39, "ssn": "<b>816-86-6698</b>"},
    {"id": "jxr8h3v", "vitals": "81,69,58", "name": "Shelton Powlowski", "age": 77, "ssn": "<b>810-63-7478</b>"},
    {"id": "d7lwaln", "vitals": "103,140,93", "name": "Sage Medhurst", "age": 19, "ssn": "<b>470-43-3841</b>"},
    {"id": "ryrtjb5", "vitals": "57,118,86", "name": "Tobias Strosin", "age": 76, "ssn": "<b>197-25-4397</b>"},
    {"id": "ox227l3", "vitals": "82,103,98", "name": "Jessi Barton", "age": 41, "ssn": "<b>700-41-0042</b>"},
    {"id": "c7vyqu2", "vitals": "103,73,90", "name": "Eliseo Feest", "age": 53, "ssn": "<b>153-01-6678</b>"},
    {"id": "i8lbviz", "vitals": "81,120,91", "name": "The Hon. Zandra Dibbert MD", "age": 55, "ssn": "<b>881-10-7835</b>"}
]
```

#### Simulate
We can simulate `IntakeFormPipeline` to make sure it works as expected. 

```ruby
docs = initial_data.map {|doc| {_source: doc} }
```

We prepare the initial data by making sure each entry has a `_source` field with the document as the value. This is slightly different than how we'll prepare the data for actual indexing. 

**Simulate the pipeline:**

```ruby
IntakeFormPipeline.simulate(docs)
```

The response should show the results of simulation, with each processor step and it’s status.  

#### Ingest

Now, let’s ingest the data into the index. We’ll use a bulk request to index our documents:

```ruby 
bulk_records = initial_data.map do |record|
	{ index: { _index: IntakeForm.index_name, data: data } }
end

IntakeForm.bulk(bulk_records)
```

Our ingest pipeline will perform all of the operations we defined as `processors` in the `IntakeFormPipeline` and index the resulting document. 

Let's see how it did:

```ruby
IntakeForm.count
#=> 10

IntakeForm.first.heart_rate
#=> 700
```

Wow! The Gov. must be having as much fun as us with a heart rate like that. 

Let's get the average heart rate per age group:

```ruby
results = IntakeForm.range(:ages, {
        field: :age, 
        ranges: [
	        {from: 19, to: 39}, 
	        {from: 40, to: 59}, 
	        {from: 60, to: 79}, 
	        {from: 80}
	    ],
        keyed: true
      }, 
      aggs: {avg_heart_rate: {avg: {field: :heart_rate}}}).size(0)

ap results.aggregations.ages.buckets
```

In this guide, we've walked through the process of creating an ingest pipeline with Elasticsearch using `stretchy-model`.

We started with a dataset of patient information, which included fields that needed preprocessing before indexing. We defined an ingest pipeline, `IntakeFormPipeline`, that transformed the data into a more useful format, including parsing CSVs, splitting names, removing HTML tags, and converting fields to integers.

We then used the `IntakeForm` model, which inherits from `StretchyModel`, to index the preprocessed data in Elasticsearch. We also demonstrated how to run aggregations on the indexed data to get insights, such as the average heart rate per age group.

This is a simple example, but ingest pipelines can be much more complex and powerful, allowing you to preprocess your data in many different ways before indexing. With `stretchy-model`, you can leverage the full power of Elasticsearch's ingest pipelines while writing Ruby code that feels familiar and idiomatic.

## Cleaning up

```ruby
IntakeForm.delete_index!
IntakeFormPipeline.delete!
```

