module OpenSearch
  module API
    module Connector
      module Actions
        # Lists all connectors.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [Integer] :from Starting offset (default: 0)
        # @option arguments [Integer] :size Specifies a max number of results to get (default: 100)
        # @option arguments [List] :index_name A comma-separated list of connector index names to fetch connector documents for
        # @option arguments [List] :connector_name A comma-separated list of connector names to fetch connector documents for
        # @option arguments [List] :service_type A comma-separated list of connector service types to fetch connector documents for
        # @option arguments [String] :query A search string for querying connectors, filtering results by matching against connector names, descriptions, and index names
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.13/list-connector-api.html
        #
        def list(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'connector.list' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          method = OpenSearch::API::HTTP_GET
          path   = '_plugins/_ml/connectors'
          params = Utils.process_params(arguments)

          perform_request(method, path, params, body, headers).body
        end
      end
    end
  end
end