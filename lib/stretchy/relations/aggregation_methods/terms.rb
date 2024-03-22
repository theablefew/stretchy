module Stretchy
  module Relations
    module AggregationMethods
      module Terms
        # Perform a terms aggregation.
        #
        # This method is used to perform a terms aggregation, which allows you to compute the frequency of different terms within a field. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The String representing the field to use for the terms aggregation.
        #     - `:size:` The Integer representing the size for the terms aggregation (optional).
        #     - `:min_doc_count:` The Integer representing the minimum document count for the terms aggregation (optional).
        #     - `:shard_min_doc_count:` The Integer representing the shard minimum document count for the terms aggregation (optional).
        #     - `:show_term_doc_count_error:` The Boolean representing the show_term_doc_count_error for the terms aggregation (optional). Default is false.
        #     - `:shard_size:` The Integer representing the shard size for the terms aggregation (optional).
        #     - `:order:` The Hash representing the order for the terms aggregation (optional).
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified terms aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Terms aggregation
        #
        # ```ruby
        #   Model.terms(:my_agg, {field: 'field_name', size: 10, min_doc_count: 1, shard_size: 100})
        #   Model.terms(:my_agg, {field: 'field_name', size: 10, min_doc_count: 1, shard_size: 100}, aggs: {...})
        # ```
        #
        def terms(name, options = {}, *aggs)
            options = {terms: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:terms)

      end
    end
  end
end