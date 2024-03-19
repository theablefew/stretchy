module OpenSearch
  module API
    module MachineLearning
	    module Models
	      module Actions
	        # Returns a model.
	        #
	        # @option arguments [String] :id The model id
	        #
	        # Example
	        # get_model(id: 109sdj0asl092)
	        #
	        # Example
	        # # Get all models
	        # get_model
          # 
          # GET /_plugins/_ml/models/<model_id>
	        def get_model(arguments = {})
            _id = arguments.delete(:id)
            headers = arguments.delete(:headers) || {}
		        method = OpenSearch::API::HTTP_GET
		        path   = if _id
		                     body = nil
		                     "_plugins/_ml/models/#{Utils.__listify(_id)}"
		                   else
		                     body = {
                            "query": {
                              "match_all": {}
                            },
                            "size": 1000
                          }
                        '_plugins/_ml/models/_search'
		                   end

		        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
		
		        perform_request(method, path, params, body, headers).body
	        end
	
	      end
	    end
    end
  end
end