module Stretchy
  module Relations
    module AggregationMethods
      module IpRange
        # Perform an ip_range aggregation.
        #
        # This method is used to perform an ip_range aggregation, which allows you to aggregate IP values into specified IP ranges. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the ip_range aggregation.
        #     - `:ranges:` The Array of Hashes representing the ranges to use for the ip_range aggregation. Example: ranges: [{to: '10.0.0.5'}, {from: '10.0.0.5'}]
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified ip_range aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Ip_range aggregation
        #
        # ```ruby
        #   Model.ip_range(:my_agg, {field: 'ip_field'})
        #   Model.ip_range(:my_agg, {field: 'ip_field'}, aggs: {...})
        # ```
        #
        def ip_range(name, options = {}, *aggs)
          options = {ip_range: options}.merge(*aggs)
          aggregation(name, options)
        end

        AggregationMethods.register!(:ip_range)

      end
    end
  end
end