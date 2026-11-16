module Stretchy
  class Backend
    class OpenSearch < Backend
      def namespace
        ::OpenSearch
      end

      def opensearch?
        true
      end
    end
  end
end
