module Stretchy
  module Relations
    module AggregationMethods
      module Children
        # Public: Perform a children aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :type - The type of children to aggregate.
        # aggs - The Hash of nested aggregations.
        #
        # Examples
        #
        #   Model.children(:my_agg, {type: 'my_type'})
        #   Model.children(:my_agg, {type: 'my_type'}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def children(name, options = {}, *aggs)
            options = {children: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:children)

      end
    end
  end
end