module Stretchy
  module Relations
    module AggregationMethods
      module Cardinality
        # Public: Perform a cardinality aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to perform the aggregation on.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.cardinality(:unique_names, {field: 'names'})
        #   Model.cardinality(:unique_names, {field: 'names'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def cardinality(name, options = {}, *aggs)
            options = {cardinality: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:cardinality)

      end
    end
  end
end