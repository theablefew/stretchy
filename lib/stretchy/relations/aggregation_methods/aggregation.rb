module Stretchy
  module Relations
    module AggregationMethods
      module Aggregation
        # Adds an aggregation to the query.
        #
        # @param name [Symbol, String] the name of the aggregation
        # @param options [Hash] a hash of options for the aggregation
        # @param block [Proc] an optional block to further configure the aggregation
        #
        # @example
        #   Model.aggregation(:avg_price, field: :price)
        #   Model.aggregation(:price_ranges) do
        #     range field: :price, ranges: [{to: 100}, {from: 100, to: 200}, {from: 200}]
        #   end
        #
        # Aggregation results are available in the `aggregations` method of the results under name provided in the aggregation.
        #
        # @example
        #  results = Model.where(color: :blue).aggregation(:avg_price, field: :price)
        #  results.aggregations.avg_price
        #
        # @return [Stretchy::Relation] a new relation
        def aggregation(name, options = {}, &block)
            spawn.aggregation!(name, options, &block)
        end

        def aggregation!(name, options = {}, &block) # :nodoc:
            self.aggregation_values += [{name: name, args: assume_keyword_field(options)}]
            self
        end

        AggregationMethods.register!(:aggregation)

      end
    end
  end
end
