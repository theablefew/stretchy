module Stretchy
  module Relations
    module AggregationMethods
      module Sum
        # Public: Perform a sum aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the sum aggregation.
        #           :missing - The missing to use for the sum aggregation.
        #           :script - The script to use for the sum aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.sum(:my_agg, {field: 'field_name'})
        #   Model.sum(:my_agg, {field: 'field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def sum(name, options = {}, *aggs)
            options = {sum: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:sum)

      end
    end
  end
end