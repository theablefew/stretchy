module Stretchy
  module Relations
    module AggregationMethods
      module TopHits
        # Public: Perform a top_hits aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :size - The size for the top_hits aggregation.
        #           :from - The from for the top_hits aggregation.
        #           :sort - The sort for the top_hits aggregation.
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.top_hits(:my_agg, {size: 10, sort: {...}})
        #   Model.top_hits(:my_agg, {size: 10, sort: {...}}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def top_hits(name, options = {}, *aggs)
            options = {top_hits: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:top_hits)

      end
    end
  end
end