module Stretchy
  module Relations
    module AggregationMethods
      module PercentileRanks
        # Public: Perform a percentile_ranks aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the percentile_ranks aggregation.
        #           :values - The values to use for the percentile_ranks aggregation.
        #           :keyed -  associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true
        #           :script - The script to use for the percentile_ranks aggregation. (optional)  script: {source: "doc['field_name'].value", lang: "painless"}
        #           :hdr - The hdr to use for the percentile_ranks aggregation. (optional) hdr: {number_of_significant_value_digits: 3}
        #           :missing - The missing to use for the percentile_ranks aggregation. (optional) missing: 10
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]})
        #   Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def percentile_ranks(name, options = {}, *aggs)
            options = {percentile_ranks: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:percentile_ranks)

      end
    end
  end
end