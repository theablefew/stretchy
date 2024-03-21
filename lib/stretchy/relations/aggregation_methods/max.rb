module Stretchy
  module Relations
    module AggregationMethods
      module Max
        # Public: Perform a max aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the max aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.max(:my_agg, {field: 'field_name'})
        #   Model.max(:my_agg, {field: 'field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def max(name, options = {}, *aggs)
            options = {max: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:max)

      end
    end
  end
end