module Stretchy
  module Relations
    module AggregationMethods
      module ValueCount
        # Public: Perform a value_count aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the value_count aggregation.
        #           :script - The script to use for the value_count aggregation. (optional) script: {source: "doc['field_name'].value", lang: "painless"}
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.value_count(:my_agg, {field: 'field_name'})
        #   Model.value_count(:my_agg, {field: 'field_name'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def value_count(name, options = {}, *aggs)
            options = {value_count: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:value_count)

      end
    end
  end
end