module Stretchy
  module Relations
    module AggregationMethods
      module Nested
        # Perform a nested aggregation.
        #
        # This method is used to perform a nested aggregation, which allows you to aggregate nested documents as if they were indexed as separate documents. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:path:` The String representing the path to use for the nested aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified nested aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Nested aggregation
        #
        # ```ruby
        #   Model.nested(:my_agg, {path: 'path_to_field'})
        #   Model.nested(:my_agg, {path: 'path_to_field'}, aggs: {...})
        # ```
        #
        def nested(name, options = {}, *aggs)
            options = {nested: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:nested)

      end
    end
  end
end