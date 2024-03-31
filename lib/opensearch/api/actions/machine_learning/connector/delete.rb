module OpenSearch
  module API
    module Connector
      module Actions
        # Deletes a connector.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :connector_id The unique identifier of the connector to be deleted.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.13/delete-connector-api.html
        #
        def delete(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'connector.delete' }

          defined_params = [:connector_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'connector_id' missing" unless arguments[:connector_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _connector_id = arguments.delete(:connector_id)

          method = OpenSearch::API::HTTP_DELETE
          path   = "_plugins/_ml/connectors/#{Utils.__listify(_connector_id)}"
          params = {}

          perform_request(method, path, params, body, headers).body
        end
      end
    end
  end
end