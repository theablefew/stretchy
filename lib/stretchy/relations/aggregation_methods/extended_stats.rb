module Stretchy
  module Relations
    module AggregationMethods
      module ExtendedStats
        # Public: Perform an extended_stats aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the extended_stats aggregation.
        #           :sigma - The sigma for the extended_stats aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.extended_stats(:my_agg, {field: 'field_name', sigma: 1.0})
        #   Model.extended_stats(:my_agg, {field: 'field_name', sigma: 1.0}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def extended_stats(name, options = {}, *aggs)
            options = {extended_stats: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:extended_stats)

      end
    end
  end
end