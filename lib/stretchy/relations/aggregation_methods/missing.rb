module Stretchy
  module Relations
    module AggregationMethods
      module Missing
        # Perform a missing aggregation.
        #
        # This method is used to perform a missing aggregation, which allows you to find all documents where a field is missing or null. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the missing aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified missing aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Missing aggregation
        #
        # ```ruby
        #   Model.missing(:my_agg, {field: 'field_name'})
        #   Model.missing(:my_agg, {field: 'field_name'}, aggs: {...})
        # ```
        #
        def missing(name, options = {}, *aggs)
            options = {missing: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:missing)

      end
    end
  end
end