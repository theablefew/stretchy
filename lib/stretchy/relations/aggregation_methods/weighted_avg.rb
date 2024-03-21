module Stretchy
  module Relations
    module AggregationMethods
      module WeightedAvg
        # Public: Perform a weighted_avg aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :value - The value field to use for the weighted_avg aggregation. {value: { field: 'price', missing: 0}}
        #           :weight - The weight field to use for the weighted_avg aggregation. {weight: { field: 'weight', missing: 0}}
        #           :format - The format for the weighted_avg aggregation. (optional)
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.weighted_avg(:my_agg, {value_field: 'value_field_name', weight_field: 'weight_field_name'})
        #   Model.weighted_avg(:my_agg, {value_field: 'value_field_name', weight_field: 'weight_field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def weighted_avg(name, options = {}, *aggs)
            options = {weighted_avg: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:weighted_avg)

      end
    end
  end
end