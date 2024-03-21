module Stretchy
  module Relations
    module AggregationMethods
      module Avg
        # Public: Perform an avg aggregation.
        #
        # name    - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to calculate the average on.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.aggregation(:average_price, field: :price)
        #
        # Returns a new Stretchy::Relation.
        def avg(name, options = {}, *aggs)
            options = {avg: options}.merge(*aggs)
            aggregation(name, options)
        end
      
        AggregationMethods.register!(:avg)
      end
    end
  end
end