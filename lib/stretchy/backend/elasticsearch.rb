module Stretchy
  class Backend
    class Elasticsearch < Backend
      def namespace
        ::Elasticsearch
      end
    end
  end
end
