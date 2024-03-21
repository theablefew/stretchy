module Stretchy
  module Relations
    module AggregationMethods
      module Nested
        # Public: Perform a nested aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :path - The path to use for the nested aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.nested(:my_agg, {path: 'path_to_field'})
        #   Model.nested(:my_agg, {path: 'path_to_field'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def nested(name, options = {}, *aggs)
            options = {nested: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:nested)

      end
    end
  end
end