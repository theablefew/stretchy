module Stretchy
  module Relations
    module AggregationMethods
      module ReverseNested
        # Public: Perform a reverse_nested aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}).
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.reverse_nested(:my_agg)
        #   Model.reverse_nested(:my_agg, {}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def reverse_nested(name, options = {}, *aggs)
            options = {reverse_nested: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:reverse_nested)

      end
    end
  end
end