module Stretchy
  module Relations
    module AggregationMethods
      module BucketSort
        # Perform a bucket_sort aggregation.
        #
        # This method is used to sort the buckets of a parent multi-bucket aggregation. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The Symbol or String representing the field to sort on.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified bucket_sort aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Bucket_sort aggregation
        #
        # ```ruby
        #   Model.bucket_sort(:my_agg, {field: 'my_field'})
        #   Model.bucket_sort(:my_agg, {field: 'my_field'}, aggs: {...})
        # ```
        #
        # Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.
        #
        # ```ruby
        #   results = Model.where(color: :blue).bucket_sort(:my_agg, {field: 'my_field'})
        #   results.aggregations.my_agg
        # ```
        #
        def bucket_sort(name, options = {}, *aggs)
            options = {bucket_sort: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:bucket_sort)

      end
    end
  end
end