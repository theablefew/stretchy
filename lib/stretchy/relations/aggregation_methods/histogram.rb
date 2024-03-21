module Stretchy
  module Relations
    module AggregationMethods
      module Histogram
        # Public: Perform a histogram aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the histogram aggregation.
        #           :interval - The interval for the histogram aggregation.
        #           :min_doc_count - The minimum document count for the histogram aggregation.
        #           :extended_bounds - The extended bounds for the histogram aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.histogram(:my_agg, {field: 'field_name', interval: 5})
        #   Model.histogram(:my_agg, {field: 'field_name', interval: 5}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def histogram(name, options = {}, *aggs)
            options = {histogram: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:histogram)

      end
    end
  end
end