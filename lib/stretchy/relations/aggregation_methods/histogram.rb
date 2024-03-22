module Stretchy
  module Relations
    module AggregationMethods
      module Histogram
        # Perform a histogram aggregation.
        #
        # This method is used to perform a histogram aggregation, which allows you to aggregate data into buckets of a certain interval. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the histogram aggregation.
        #     - `:interval:` The Integer representing the interval for the histogram aggregation.
        #     - `:min_doc_count:` The Integer representing the minimum document count for the histogram aggregation.
        #     - `:extended_bounds:` The Hash representing the extended bounds for the histogram aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified histogram aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Histogram aggregation
        #
        # ```ruby
        #   Model.histogram(:my_agg, {field: 'field_name', interval: 5})
        #   Model.histogram(:my_agg, {field: 'field_name', interval: 5}, aggs: {...})
        # ```
        #
        def histogram(name, options = {}, *aggs)
            options = {histogram: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:histogram)

      end
    end
  end
end