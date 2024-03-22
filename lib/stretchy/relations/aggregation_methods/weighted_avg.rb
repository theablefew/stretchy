module Stretchy
  module Relations
    module AggregationMethods
      module WeightedAvg
        # Perform a weighted_avg aggregation.
        #
        # This method is used to perform a weighted_avg aggregation, which allows you to compute a weighted average of a specified field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:value:` The Hash representing the value field to use for the weighted_avg aggregation. Example: value: { field: 'price', missing: 0}
        #     - `:weight:` The Hash representing the weight field to use for the weighted_avg aggregation. Example: weight: { field: 'weight', missing: 0}
        #     - `:format:` The String representing the format for the weighted_avg aggregation (optional).
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified weighted_avg aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Weighted_avg aggregation
        #
        # ```ruby
        #   Model.weighted_avg(:my_agg, {value: {field: 'value_field_name'}, weight: {field: 'weight_field_name'}})
        #   Model.weighted_avg(:my_agg, {value: {field: 'value_field_name'}, weight: {field: 'weight_field_name'}}, aggs: {...})
        # ```
        #
        def weighted_avg(name, options = {}, *aggs)
            options = {weighted_avg: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:weighted_avg)

      end
    end
  end
end