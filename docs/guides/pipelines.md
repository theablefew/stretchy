# Pipelines
>[!NOTE|style:flat]
> _coming soon..._

## Ingest
Create a `Stretchy::Pipeline` to allow interacting with Ingestion Pipelines [^1] [^2]
```ruby
class NLPSparsePipeline < Stretchy::Pipeline

	#inferred from class by default
	name 'nlp-sparse-pipeline' 
	
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


## Search