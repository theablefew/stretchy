module Stretchy
  module Relations
    module AggregationMethods
      module Terms
        # Public: Perform a terms aggregation.
        #
        # name - The Symbol or String name of the aggregation.
        # options - The Hash options used to refine the aggregation (default: {}):
        #           :field - The field to use for the terms aggregation.
        #           :size - The size for the terms aggregation. (optional)
        #           :min_doc_count - The minimum document count for the terms aggregation. (optional)
        #           :shard_min_doc_count - The shard minimum document count for the terms aggregation. (optional)
        #           :show_term_doc_count_error - The show_term_doc_count_error for the terms aggregation. (optional) default: false
        #           :shard_size - The shard size for the terms aggregation. (optional)
        #           :order - The order for the terms aggregation. (optional)
        #           
        # aggs - The Array of additional nested aggregations (optional).
        #
        # Examples
        #
        #   Model.terms(:my_agg, {field: 'field_name', size: 10, min_doc_count: 1, shard_size: 100})
        #   Model.terms(:my_agg, {field: 'field_name', size: 10, min_doc_count: 1, shard_size: 100}, aggs: {...})
        #
        # Returns a new Stretchy::Relation.
        def terms(name, options = {}, *aggs)
            options = {terms: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:terms)

      end
    end
  end
end