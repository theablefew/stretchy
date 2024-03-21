module Stretchy
  module Relations
    module AggregationMethods
      module Range
        # Public: Perform a range aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the range aggregation.
        #           :ranges - The ranges to use for the range aggregation.
        #           :keyed - associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.range(:my_agg, {field: 'field_name', ranges: [{from: 1, to: 2}, {from: 2, to: 3}]})
        #   Model.range(:my_agg, {field: 'field_name', ranges: [{from: 1, to: 2}, {from: 2, to: 3}]}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def range(name, options = {}, *aggs)
            options = {range: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:range)

      end
    end
  end
end