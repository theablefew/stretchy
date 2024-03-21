module Stretchy
  module Relations
    module AggregationMethods
      module Composite
        # Public: Perform a composite aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :sources - The sources to use for the composite aggregation.
        #           :size - The size of the composite aggregation.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.composite(:my_agg, {sources: [...], size: 100})
        #   Model.composite(:my_agg, {sources: [...], size: 100}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def composite(name, options = {}, *aggs)
            options = {composite: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:composite)

      end
    end
  end
end