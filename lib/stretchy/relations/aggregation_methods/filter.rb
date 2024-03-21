module Stretchy
  module Relations
    module AggregationMethods
      module Filter
        # Public: Perform a filter_agg aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :filter - The filter to use for the filter_agg aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.filter_agg(:my_agg, {filter: {...}})
        #   Model.filter_agg(:my_agg, {filter: {...}}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def filter(name, options = {}, *aggs)
            options = {filter: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:filter)

      end
    end
  end
end