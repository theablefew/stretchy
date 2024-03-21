module Stretchy
  module Relations
    module AggregationMethods
      module Missing
        # Public: Perform a missing aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the missing aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.missing(:my_agg, {field: 'field_name'})
        #   Model.missing(:my_agg, {field: 'field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def missing(name, options = {}, *aggs)
            options = {missing: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:missing)

      end
    end
  end
end