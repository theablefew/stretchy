module Stretchy
  module Relations
    module AggregationMethods
      module IpRange
        # Public: Perform an ip_range aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the ip_range aggregation.
        #           :ranges - The ranges to use for the ip_range aggregation. ranges: [{to: '10.0.0.5'}, {from: '10.0.0.5'}]
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.ip_range(:my_agg, {field: 'ip_field'})
        #   Model.ip_range(:my_agg, {field: 'ip_field'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def ip_range(name, options = {}, *aggs)
            options = {ip_range: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:ip_range)

      end
    end
  end
end