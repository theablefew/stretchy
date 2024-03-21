module Stretchy
  module Relations
    module AggregationMethods
      module Global
        # Public: Perform a global aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}).
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.global(:my_agg)
        #   Model.global(:my_agg, {}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def global(name, options = {}, *aggs)
            options = {global: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:global)

      end
    end
  end
end