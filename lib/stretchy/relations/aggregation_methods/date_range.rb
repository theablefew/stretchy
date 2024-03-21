module Stretchy
  module Relations
    module AggregationMethods
      module DateRange
        # Public: Perform a date_range aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the date_range aggregation.
        #           :format - The format for the date_range aggregation.
        #           :time_zone - The time zone for the date_range aggregation.
        #           :ranges - The ranges for the date_range aggregation.
        #           :keyed - The keyed option for the date_range aggregation.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.date_range(:my_agg, {field: 'date', format: 'MM-yyyy', time_zone: 'UTC', ranges: [{to: 'now', from: 'now-1M'}]})
        #   Model.date_range(:my_agg, {field: 'date', format: 'MM-yyyy', time_zone: 'UTC', ranges: [{to: 'now', from: 'now-1M'}]}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def date_range(name, options = {}, *aggs)
            options = {date_range: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:date_range)

      end
    end
  end
end