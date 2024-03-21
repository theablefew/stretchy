module Stretchy
  module Relations
    module AggregationMethods
      module GeoBounds
        # Public: Perform a geo_bounds aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the geo_bounds aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.geo_bounds(:my_agg, {field: 'location_field'})
        #   Model.geo_bounds(:my_agg, {field: 'location_field'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def geo_bounds(name, options = {}, *aggs)
            options = {geo_bounds: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:geo_bounds)

      end
    end
  end
end