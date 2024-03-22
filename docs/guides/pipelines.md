# Pipelines

Pipelines follow a specific convention for storing pipeline definitions. This helps us keep our code organized and easy to navigate.

Generally, pipelines can be stored in `app/pipelines`. However, if you have a mix of ingest and search pipelines it's good practice to break them out into their own namespace.

For ingest pipelines, we store each pipeline in its own Ruby file inside the `app/pipelines/ingest` directory. The file name matches the pipeline name. For example, the definition for an ingest pipeline named `example_pipeline` would be stored in `app/pipelines/ingest/example_pipeline.rb`.

Similarly, for search pipelines, we store each pipeline in its own Ruby file inside the `app/pipelines/search` directory. Again, the file name matches the pipeline name. So, a search pipeline named `example_pipeline` would be stored in `app/pipelines/search/example_pipeline.rb`.

This convention makes it easy to find the definition for a specific pipeline, whether it's an ingest pipeline or a search pipeline.

- *app/pipelines/ingest/example_ingest_pipeline.rb*
- *app/pipelines/search/example_search_pipeline.rb*

--- 

## Defining a Pipeline

A pipeline in `stretchy-model` is defined as a Ruby class that inherits from `Stretchy::Pipeline`. It has a specific structure and includes several key components:

- `pipeline_name`: This is the ID of your pipeline. By default, it's inferred from the class name. 
- `description`: This is a brief description of what your pipeline does. It's a good practice to provide a meaningful description so that others can understand the purpose of your pipeline at a glance.
- `processor`: These are the processors that your pipeline will run. A pipeline can have one or more processors. Each processor is defined with a type (like `sparse_encoding`) and a set of options. The processors are run in the order they are defined. Refer to [Ingest Processors](/guides/pipelines?id=ingest-processors) for available options.


Here's an example of a pipeline with these components:

```ruby
class NLPSparsePipeline < Stretchy::Pipeline

	#inferred from class by default
	pipeline_name 'nlp-sparse-pipeline' 
	
	description "Sparse encoding pipeline"
	
	processor :sparse_encoding, 
				model_id: 'q32Pw02BJ3squ3VZa',
				field_map: {
					body: :embedding
				}
end
```

[^1]: https://opensearch.org/docs/latest/ingest-pipelines/

[^2]: https://www.elastic.co/guide/en/elasticsearch/reference/current/ingest.html


## Managing Pipelines

### create!
This method creates a new pipeline in Elasticsearch. It uses the pipeline definition provided in the class where it's called. If a pipeline with the same name already exists, it will be overwritten.

Example:

```ruby
MyPipeline.create!
```

### delete!
This method deletes the pipeline from Elasticsearch. Be careful when using this method, as it will permanently remove the pipeline.

Example:

```ruby
MyPipeline.delete!
```

### exists?
This method checks if the pipeline exists in Elasticsearch. It returns true if the pipeline exists, and false otherwise.

Example:

```ruby
MyPipeline.exists?
```

### find
This method retrieves a pipeline from Elasticsearch using its ID. If the pipeline exists, it returns the pipeline definition. If the pipeline doesn't exist, it returns nil.


Example:
```ruby
# Find another pipeline id
MyPipeline.find('another-pipeline-id')

# Find this pipeline
MyPipeline.find
```
### all
This method returns all pipelines that currently exist in Elasticsearch. It's useful when you want to see all your pipelines at once.

Example:
```ruby
MyPipeline.all
```

### simulate

This method is used to simulate the execution of the pipeline on a set of documents. It takes two parameters: `docs`, which is an array of documents to be processed, and `verbose`, which is a boolean that controls whether detailed information about each step is included in the simulation output.

Example:

```ruby
MyPipeline.simulate([{ '_source' => { 'message' => 'hello world' } }])
```

---

## Ingest Processors
- `:append` - Adds one or more values to a field in a document.
- `:bytes` - Converts a human-readable byte value to its value in bytes.
- `:convert` - Changes the data type of a field in a document.
- `:copy` - Copies an entire object in an existing field to another field.
- `:csv` - Extracts CSVs and stores them as individual fields in a document.
- `:date` - Parses dates from fields and then uses the date or timestamp as the timestamp for a document.
- `:date_index_name` - Indexes documents into time-based indexes based on a date or timestamp field in a document.
- `:dissect` - Extracts structured fields from a text field using a defined pattern.
- `:dot_expander` - Expands a field with dots into an object field.
- `:drop` - Drops a document without indexing it or raising any errors.
- `:fail` - Raises an exception and stops the execution of a pipeline.
- `:foreach` - Allows for another processor to be applied to each element of an array or an object field in a document.
- `:geoip` - Adds information about the geographical location of an IP address.
- `:geojson-feature` - Indexes GeoJSON data into a geospatial field.
- `:grok` - Parses and structures unstructured data using pattern matching.
- `:gsub` - Replaces or deletes substrings within a string field of a document.
- `:html_strip` - Removes HTML tags from a text field and returns the plain text content.
- `:ip2geo` - Adds information about the geographical location of an IPv4 or IPv6 address.
- `:join` - Concatenates each element of an array into a single string using a separator character between each element.
- `:json` - Converts a JSON string into a structured JSON object.
- `:kv` - Automatically parses key-value pairs in a field.
- `:lowercase` - Converts text in a specific field to lowercase letters.
- `:pipeline` - Runs an inner pipeline.
- `:remove` - Removes fields from a document.
- `:script` - Runs an inline or stored script on incoming documents.
- `:set` - Sets the value of a field to a specified value.
- `:sort` - Sorts the elements of an array in ascending or descending order.
- `:sparse_encoding` - Generates a sparse vector/token and weights from text fields for neural sparse search using sparse retrieval.
- `:split` - Splits a field into an array using a separator character.
- `:text_embedding` - Generates vector embeddings from text fields for semantic search.
- `:text_image_embedding` - Generates combined vector embeddings from text and image fields for multimodal neural search.
- `:trim` - Removes leading and trailing white space from a string field.
- `:uppercase` - Converts text in a specific field to uppercase letters.
- `:urldecode` - Decodes a string from URL-encoded format.
- `:user_agent` - Extracts details from the user agent sent by a browser to its web requests.

Please note that this is not an exhaustive list. There are many more ingest processors available in Elasticsearch and OpenSearch. For a complete list and their available options, refer to the official documentation: 

- [Elasticsearch Ingest Processors](https://www.elastic.co/guide/en/elasticsearch/reference/current/processors.html)
- [OpenSearch Ingest Processors](https://opensearch.org/docs/latest/ingest-pipelines/processors/index-processors/#supported-processors)