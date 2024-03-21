module Stretchy
  module Relations
    module AggregationMethods
      module DateHistogram
        # Public: Perform a date_histogram aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the date_histogram aggregation.
        #           :interval - The interval for the date_histogram aggregation.
        #           :calendar_interval - The calendar interval for the date_histogram aggregation.
        #           :format - The format for the date_histogram aggregation.
        #           :time_zone - The time zone for the date_histogram aggregation.
        #           :min_doc_count - The minimum document count for the date_histogram aggregation.
        #           :extended_bounds - The extended bounds for the date_histogram aggregation.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.date_histogram(:my_agg, {field: 'date', interval: 'month', format: 'MM-yyyy', time_zone: 'UTC'})
        #   Model.date_histogram(:my_agg, {field: 'date', calendar_interval: :month, format: 'MM-yyyy', time_zone: 'UTC'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def date_histogram(name, options = {}, *aggs)
            options = {date_histogram: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:date_histogram)

      end
    end
  end
end