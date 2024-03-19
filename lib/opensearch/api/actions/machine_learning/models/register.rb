module OpenSearch
  module API
    module MachineLearning
	    module Models
	      module Actions
	        # Register a model.
	        #
	        # @option arguments [Hash] :body The model definition **Required**
	        # @option arguments [Boolean] :deploy Whether to deploy the model after registering it. The deploy operation is performed by calling the [Deploy Model API](https://opensearch.org/docs/latest/ml-commons-plugin/api/model-apis/deploy-model/). Default is `false`
	        #
	        # Example
          # client.machine_learing_model.register(body: {
          #	  "name": "huggingface/sentence-transformers/msmarco-distilbert-base-tas-b",
          #	  "version": "1.0.1",
          #	  "model_group_id": "Z1eQf4oB5Vm0Tdw8EIP2",
          #	  "model_format": "TORCH_SCRIPT"
          #	},
          #	deploy: true 
          #
          # POST /_plugins/_ml/models/_register
	        def register(arguments = {})
	          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
	          
	          arguments = arguments.clone
            headers = arguments.delete(:headers) || {}
	
	          method = OpenSearch::API::HTTP_POST
	          path   = "_plugins/_ml/models/_register"
	          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
	
	          body = arguments[:body]
	          perform_request(method, path, params, body, headers).body
	        end
	
	        # Register this action with its valid params when the module is loaded.
	        #
	        # @since 6.2.0
	        ParamsRegistry.register(:register, %i[
						deploy
	        ].freeze)
	      end
	    end
    end
  end
end