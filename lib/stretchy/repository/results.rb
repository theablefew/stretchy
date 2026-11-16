module Stretchy
  class Repository
    # Wraps a search response, exposing hits as deserialized records.
    #
    # Behaves like an Array of records, with `total`, `max_score` and the raw `response`.
    class Results
      include Enumerable

      attr_reader :repository, :raw_response

      delegate :each, :size, :length, :empty?, :[], :to_ary, to: :results

      def initialize(repository, response)
        @repository = repository
        @raw_response = response
      end

      def total
        total = response['hits']['total']
        total.respond_to?(:keys) ? total['value'] : total
      end

      def max_score
        response['hits']['max_score']
      end

      def each_with_hit(&block)
        results.zip(hits).each(&block)
      end

      def map_with_hit(&block)
        results.zip(hits).map(&block)
      end

      def results
        @results ||= hits.map { |document| repository.deserialize(document.to_hash) }
      end

      # The raw response with method access, e.g. `response.aggregations.my_agg`.
      def response
        @response ||= Stretchy::HashWrapper.new(raw_response)
      end

      def method_missing(method_name, *arguments, &block)
        results.respond_to?(method_name) ? results.public_send(method_name, *arguments, &block) : super
      end

      def respond_to_missing?(method_name, include_private = false)
        results.respond_to?(method_name) || super
      end

      private

      def hits
        response['hits']['hits']
      end
    end
  end
end
