module Stretchy
  class Backend
    class Elasticsearch < Backend
      def namespace
        ::Elasticsearch
      end

      def install!
        ::Elasticsearch::API.send(:include, ::Elasticsearch::API::Connector)
        ::Elasticsearch::API.send(:include, ::Elasticsearch::API::MachineLearning::Models)
      end
    end
  end
end
