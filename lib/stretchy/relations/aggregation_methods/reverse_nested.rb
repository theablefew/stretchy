module Stretchy
  module Relations
    module AggregationMethods
      module ReverseNested
        # Perform a reverse_nested aggregation.
        #
        # This method is used to perform a reverse_nested aggregation, which allows you to access data in the parent document from within a nested document. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:path:` The String representing the path to use for the reverse_nested aggregation (optional).
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified reverse_nested aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Reverse_nested aggregation
        #
        # ```ruby
        #   Model.reverse_nested(:my_agg)
        #   Model.reverse_nested(:my_agg, {}, aggs: {...})
        # ```
        #
        def reverse_nested(name, options = {}, *aggs)
            options = {reverse_nested: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:reverse_nested)

      end
    end
  end
end