module Stretchy
  module Relations
    module AggregationMethods
      module Sampler
        # Perform a sampler aggregation.
        #
        # This method is used to perform a sampler aggregation, which allows you to create a representative sample of a larger data set. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:shard_size:` The Integer representing the shard size to use for the sampler aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified sampler aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Sampler aggregation
        #
        # ```ruby
        #   Model.sampler(:my_agg, {shard_size: 100})
        #   Model.sampler(:my_agg, {shard_size: 100}, aggs: {...})
        # ```
        #
        def sampler(name, options = {}, *aggs)
            options = {sampler: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:sampler)

      end
    end
  end
end