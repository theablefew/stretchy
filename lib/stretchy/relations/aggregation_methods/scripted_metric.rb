module Stretchy
  module Relations
    module AggregationMethods
      module ScriptedMetric
        # Perform a scripted_metric aggregation.
        #
        # This method is used to perform a scripted_metric aggregation, which allows you to define your own aggregations using scripts. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:init_script:` The String representing the initialization script for the scripted_metric aggregation.
        #     - `:map_script:` The String representing the map script for the scripted_metric aggregation.
        #     - `:combine_script:` The String representing the combine script for the scripted_metric aggregation.
        #     - `:reduce_script:` The String representing the reduce script for the scripted_metric aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified scripted_metric aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Scripted_metric aggregation
        #
        # ```ruby
        #   Model.scripted_metric(:my_agg, {init_script: '...', map_script: '...', combine_script: '...', reduce_script: '...'})
        #   Model.scripted_metric(:my_agg, {init_script: '...', map_script: '...', combine_script: '...', reduce_script: '...'}, aggs: {...})
        # ```
        #
        def scripted_metric(name, options = {}, *aggs)
            options = {scripted_metric: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:scripted_metric)

      end
    end
  end
end