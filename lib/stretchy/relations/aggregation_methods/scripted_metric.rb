module Stretchy
  module Relations
    module AggregationMethods
      module ScriptedMetric
        # Public: Perform a scripted_metric aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :init_script - The initialization script for the scripted_metric aggregation.
        #           :map_script - The map script for the scripted_metric aggregation.
        #           :combine_script - The combine script for the scripted_metric aggregation.
        #           :reduce_script - The reduce script for the scripted_metric aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.scripted_metric(:my_agg, {init_script: '...', map_script: '...', combine_script: '...', reduce_script: '...'})
        #   Model.scripted_metric(:my_agg, {init_script: '...', map_script: '...', combine_script: '...', reduce_script: '...'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def scripted_metric(name, options = {}, *aggs)
            options = {scripted_metric: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:scripted_metric)

      end
    end
  end
end