module Stretchy
  module Relations
    module AggregationMethods
      module TopHits
        # Perform a top_hits aggregation.
        #
        # This method is used to perform a top_hits aggregation, which allows you to return the top matching hits for each bucket of a parent aggregation. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:size:` The Integer representing the size for the top_hits aggregation.
        #     - `:from:` The Integer representing the from for the top_hits aggregation.
        #     - `:sort:` The Hash or Array representing the sort for the top_hits aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified top_hits aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Top_hits aggregation
        #
        # ```ruby
        #   Model.top_hits(:my_agg, {size: 10, sort: {...}})
        #   Model.top_hits(:my_agg, {size: 10, sort: {...}}, aggs: {...})
        # ```
        #
        def top_hits(name, options = {}, *aggs)
            options = {top_hits: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:top_hits)

      end
    end
  end
end