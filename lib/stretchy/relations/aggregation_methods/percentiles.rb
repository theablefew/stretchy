module Stretchy
  module Relations
    module AggregationMethods
      module Percentiles
        # Public: Perform a percentiles aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the percentiles aggregation.
        #           :percents - The percents to use for the percentiles aggregation. percents: [95, 99, 99.9]
        #           :keyed - associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true
        #           :tdigest - The tdigest to use for the percentiles aggregation. (optional) tdigest: {compression: 100, execution_hint: "high_accuracy"}
        #                   :compression - The compression factor to use for the t-digest algorithm. A higher compression factor will yield more accurate percentiles, but will require more memory. The default value is 100.
        #                   :execution_hint - The execution_hint to use for the t-digest algorithm. (optional) execution_hint: "auto"
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.percentiles(:my_agg, {field: 'field_name', percents: [1, 2, 3]})
        #   Model.percentiles(:my_agg, {field: 'field_name', percents: [1, 2, 3]}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def percentiles(name, options = {}, *aggs)
            options = {percentiles: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:percentiles)

      end
    end
  end
end