module OpenSearch
  module API
    module MachineLearning
	    module Models
	      module Actions
	        # Register a model.
	        #
	        # @option arguments [String] :model_id The model id
	        # @option arguments [Hash] :body The deploy options
	        #
          # 
          # POST /_plugins/_ml/models/<model_id>/_predict
	        def predict(arguments = {})
						raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
	          _id = arguments.delete(:model_id)
	          arguments = arguments.clone
						headers = arguments.delete(:headers) || {}
	
	          method = OpenSearch::API::HTTP_POST
	          path   = "_plugins/_ml/models/#{Utils.__listify(_id)}/_predict"
	          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
	
	          body = arguments[:body]
            perform_request(method, path, params, body, headers).body
	        end
	
	      end
	    end
    end
  end
end