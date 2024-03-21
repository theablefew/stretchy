module Stretchy
  module Relations
    module AggregationMethods
      module Min

        # Public: Perform a min aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the min aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.min(:my_agg, {field: 'field_name'})
        #   Model.min(:my_agg, {field: 'field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def min(name, options = {}, *aggs)
            options = {min: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:min)

      end
    end
  end
end