module Stretchy
  module Relations
    module AggregationMethods
      module Stats
        # Public: Perform a stats aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the stats aggregation.
        #           :missing - The missing to use for the stats aggregation.
        #           :script - The script to use for the stats aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.stats(:my_agg, {field: 'field_name'})
        #   Model.stats(:my_agg, {field: 'field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def stats(name, options = {}, *aggs)
            options = {stats: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:stats)

      end
    end
  end
end