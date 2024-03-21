module Stretchy
  module Relations
    module AggregationMethods
      module Sampler
        # Public: Perform a sampler aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :shard_size - The shard size to use for the sampler aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.sampler(:my_agg, {shard_size: 100})
        #   Model.sampler(:my_agg, {shard_size: 100}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def sampler(name, options = {}, *aggs)
            options = {sampler: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:sampler)

      end
    end
  end
end