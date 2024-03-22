module Stretchy
  module Relations
    module AggregationMethods
      module Range
        # Perform a range aggregation.
        #
        # This method is used to perform a range aggregation, which allows you to aggregate data into specified ranges. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the range aggregation.
        #     - `:ranges:` The Array of Hashes representing the ranges to use for the range aggregation. Example: ranges: [{from: 1, to: 2}, {from: 2, to: 3}]
        #     - `:keyed:` The Boolean that associates a unique string key with each bucket and returns the ranges as a hash rather than an array. Default is true.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified range aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Range aggregation
        #
        # ```ruby
        #   Model.range(:my_agg, {field: 'field_name', ranges: [{from: 1, to: 2}, {from: 2, to: 3}]})
        #   Model.range(:my_agg, {field: 'field_name', ranges: [{from: 1, to: 2}, {from: 2, to: 3}]}, aggs: {...})
        # ```
        #
        def range(name, options = {}, *aggs)
            options = {range: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:range)

      end
    end
  end
end