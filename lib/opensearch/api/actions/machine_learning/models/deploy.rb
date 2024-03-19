module OpenSearch
  module API
    module MachineLearning
	    module Models
	      module Actions
	        # Register a model.
	        #
	        # @option arguments [String] :id The model id
	        # @option arguments [Hash] :body The deploy options
	        #
          # 
          # POST /_plugins/_ml/models/<model_id>/_deploy
	        def deploy(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
	          _id = arguments.delete(:id)
	          arguments = arguments.clone
            headers = arguments.delete(:headers) || {}
	
	          method = OpenSearch::API::HTTP_POST
	          path   = "_plugins/_ml/models/#{Utils.__listify(_id)}/_deploy"
	          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
	
	          body = arguments[:body]
	          perform_request(method, path, params, body, headers).body
	        end
	
	      end
	    end
    end
  end
end