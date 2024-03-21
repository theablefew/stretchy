module Stretchy
  module Relations
    module AggregationMethods
      module BucketScript
        # Public: Perform a bucket_script aggregation.
        #
        # name    - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :buckets_path - The paths to the buckets.
        #           :script       - The script to execute.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.aggregation(:total_sales, script: "params.tShirtsSold * params.price", buckets_path: {tShirtsSold: "tShirtsSold", price: "price"})
        #
        # Returns a new Stretchy::Relation.
        def bucket_script(name, options = {}, *aggs)
          options = {bucket_script: options}.merge(*aggs)
          aggregation(name, options)
        end

        AggregationMethods.register!(:bucket_script)

      end
    end
  end
end