module OpenSearch
  module API
    module Connector
      module Actions; end

      # Client for the "connector" namespace (includes the {Connector::Actions} methods)
      #
      class ConnectorClient
        include Common::Client, Common::Client::Base, Connector::Actions
      end

      # Proxy method for {ConnectorClient}, available in the receiving object
      #
      def connector
        @connector ||= ConnectorClient.new(self)
      end
    end
  end
end