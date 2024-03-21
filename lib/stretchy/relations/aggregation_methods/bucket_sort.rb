module Stretchy
  module Relations
    module AggregationMethods
      module BucketSort
        # Public: Perform a bucket_sort aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to sort on.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.bucket_sort(:my_agg, {field: 'my_field'})
        #   Model.bucket_sort(:my_agg, {field: 'my_field'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def bucket_sort(name, options = {}, *aggs)
            options = {bucket_sort: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:bucket_sort)

      end
    end
  end
end