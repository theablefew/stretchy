module OpenSearch
  module API
    module Connector
      module Actions
        # Creates a connector.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The connector configuration. (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.13/create-connector-api.html
        #
        def post(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'connector.post' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          method = OpenSearch::API::HTTP_POST
          path   = '_plugins/_ml/connectors/_create'
          params = {}

          perform_request(method, path, params, body, headers).body
        end
      end
    end
  end
end