module Stretchy
  module Relations
    module AggregationMethods
      module Composite
        # Perform a composite aggregation.
        #
        # This method is used to perform a composite aggregation, which allows you to collect terms or histogram aggregations on high cardinality fields. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:sources:` The Array representing the sources to use for the composite aggregation.
        #     - `:size:` The Integer representing the size of the composite aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified composite aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Composite aggregation
        #
        # ```ruby
        #   Model.composite(:my_agg, {sources: [...], size: 100})
        #   Model.composite(:my_agg, {sources: [...], size: 100}, aggs: {...})
        # ```
        #
        def composite(name, options = {}, *aggs)
            options = {composite: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:composite)

      end
    end
  end
end