module Stretchy
  module Relations
    module AggregationMethods
      module TopMetrics
        # Public: Perform a top_metrics aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :metrics - The metrics to use for the top_metrics aggregation. metrics: [{field: 'field_name', type: 'max'}, {field: 'field_name', type: 'min']
        #           :field - The field to use for the top_metrics aggregation. (optional)
        #           :size - The size for the top_metrics aggregation. (optional)
        #           :sort - The sort for the top_metrics aggregation. (optional)
        #           :missing - The missing for the top_metrics aggregation. (optional)
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.top_metrics(:my_agg, {metrics: ['metric1', 'metric2']})
        #   Model.top_metrics(:my_agg, {metrics: ['metric1', 'metric2']}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def top_metrics(name, options = {}, *aggs)
            options = {top_metrics: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:top_metrics)

      end
    end
  end
end