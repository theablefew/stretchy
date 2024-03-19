module Elasticsearch
  module API
    module MachineLearning
	    module Models
	      module Actions
	        # Returns a model.
	        #
	        # @option arguments [String] :id The model id
          # @option arguments [Hash] :headers Custom HTTP headers
	        #
	        # Example
	        # delete_model(id: 109sdj0asl092)
          # 
          # DELETE /_plugins/_ml/models/<model_id>
	        def delete_model(arguments = {})
		        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
		        headers = arguments.delete(:headers) || {}
		        
            _id = arguments.delete(:id)
				
		        method = Elasticsearch::API::HTTP_DELETE
		        path   = "_plugins/_ml/models/#{Utils.__listify(_id)}"
		        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
				
            body = nil
		        perform_request(method, path, params, body, headers).body
	        end
	
	      end
	    end
    end
  end
end