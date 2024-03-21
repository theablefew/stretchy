module Stretchy
  module Relations
    module AggregationMethods
      module GeoCentroid
        # Public: Perform a geo_centroid aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the geo_centroid aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.geo_centroid(:my_agg, {field: 'location_field'})
        #   Model.geo_centroid(:my_agg, {field: 'location_field'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def geo_centroid(name, options = {}, *aggs)
            options = {geo_centroid: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:geo_centroid)

      end
    end
  end
end