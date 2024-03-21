module Stretchy
  module Relations
    module AggregationMethods
      module BucketSelector
        # Public: Perform a bucket_selector aggregation.
        #
        # name    - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :script - The script to determine whether the current bucket will be retained.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.aggregation(:sales_bucket_filter, script: "params.totalSales > 200", buckets_path: {totalSales: "totalSales"})
        #
        # Returns a new Stretchy::Relation.
        def bucket_selector(name, options = {}, *aggs)
          options = {bucket_selector: options}.merge(*aggs)
          aggregation(name, options)
        end

        AggregationMethods.register!(:bucket_selector)

      end
    end
  end
end