module Elasticsearch
  module API
    module MachineLearning
	    module Models
	      module Actions
	        # Returns a model.
	        #
	        # @option arguments [String] :id The model id
	        # @option arguments [Hash] :body The request fields
	        #
	        # Example
	        # update_model(id: 109sdj0asl092, "rate_limiter": {
          #    "limit": "4",
          #    "unit": "MINUTES"
          #  }
          # )
          # 
          # PUT /_plugins/_ml/models/<model_id>
	        def update_model(arguments = {})
		        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
		        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
		        
            _id = arguments.delete(:id)

            headers = arguments.delete(:headers) || {}

		        method = Elasticsearch::API::HTTP_PUT
		        path   = "_plugins/_ml/models/#{Utils.__listify(_id)}"
		        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
				
            body = arguments[:body]
		        perform_request(method, path, params, body, headers).body
	        end
	
	      end
	    end
    end
  end
end