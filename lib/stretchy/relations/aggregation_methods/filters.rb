module Stretchy
  module Relations
    module AggregationMethods
      module Filters
        # Public: Perform a filters aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :filters - The filters to use for the filters aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.filters(:my_agg, {filters: {...}})
        #   Model.filters(:my_agg, {filters: {...}}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def filters(name, options = {}, *aggs)
            options = {filters: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:filters)

      end
    end
  end
end