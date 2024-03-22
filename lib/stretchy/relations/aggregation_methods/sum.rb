module Stretchy
  module Relations
    module AggregationMethods
      module Sum
        # Perform a sum aggregation.
        #
        # This method is used to perform a sum aggregation, which allows you to compute the sum of a numeric field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the sum aggregation.
        #     - `:missing:` The value to use for the sum aggregation when a field is missing in a document. Example: missing: 10
        #     - `:script:` The Hash representing the script to use for the sum aggregation. Example: script: {source: "doc['field_name'].value", lang: "painless"}
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified sum aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Sum aggregation
        #
        # ```ruby
        #   Model.sum(:my_agg, {field: 'field_name'})
        #   Model.sum(:my_agg, {field: 'field_name'}, aggs: {...})
        # ```
        #
        def sum(name, options = {}, *aggs)
            options = {sum: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:sum)

      end
    end
  end
end