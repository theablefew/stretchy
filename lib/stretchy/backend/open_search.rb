module Stretchy
  class Backend
    class OpenSearch < Backend
      def namespace
        ::OpenSearch
      end

      def opensearch?
        true
      end

      def install!
        require 'opensearch/api/namespace/machine_learning/model'
        require 'opensearch/api/namespace/connector'

        ::OpenSearch::API.send(:include, ::OpenSearch::API::MachineLearning::Models)
        ::OpenSearch::API.send(:include, ::OpenSearch::API::Connector)
      end
    end
  end
end
