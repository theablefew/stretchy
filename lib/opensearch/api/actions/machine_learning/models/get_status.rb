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
          # GET /_plugins/_ml/tasks/<task_id>
	        def get_status(arguments = {})
						raise ArgumentError, "Required argument 'task_id' missing" unless arguments[:task_id]
	          _id = arguments.delete(:task_id)
	          arguments = arguments.clone
						headers = arguments.delete(:headers) || {}
	
	          method = OpenSearch::API::HTTP_GET
	          path   = "_plugins/_ml/tasks/#{Utils.__listify(_id)}"
	          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
	
						body = nil
	          perform_request(method, path, params, body, headers).body
	        end
	
	      end
	    end
    end
  end
end