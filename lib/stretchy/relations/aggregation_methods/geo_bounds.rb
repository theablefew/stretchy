module Stretchy
  module Relations
    module AggregationMethods
      module GeoBounds
        # Perform a geo_bounds aggregation.
        #
        # This method is used to perform a geo_bounds aggregation, which allows you to find the bounding box containing all geo_point values for a particular field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the geo_bounds aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified geo_bounds aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Geo_bounds aggregation
        #
        # ```ruby
        #   Model.geo_bounds(:my_agg, {field: 'location_field'})
        #   Model.geo_bounds(:my_agg, {field: 'location_field'}, aggs: {...})
        # ```
        #
        def geo_bounds(name, options = {}, *aggs)
            options = {geo_bounds: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:geo_bounds)

      end
    end
  end
end