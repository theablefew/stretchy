module Stretchy
  module Relations
    module AggregationMethods
      module Filters
        # Perform a filters aggregation.
        #
        # This method is used to perform a filters aggregation, which allows you to apply several filters and return the document count for each filter. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:filters:` The Hash representing the filters to use for the filters aggregation.
        # - `aggs:` The Array of Hashes representing nested aggregations (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified filters aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Filters aggregation
        #
        # ```ruby
        #   Model.filters(:my_agg, {filters: {...}})
        #   Model.filters(:my_agg, {filters: {...}}, aggs: {...})
        # ```
        #
        # Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.
        #
        # ```ruby
        #   results = Model.where(color: :blue).filters(:my_agg, {filters: {...}})
        #   results.aggregations.my_agg
        # ```
        #
        def filters(name, options = {}, *aggs)
            options = {filters: options}.merge(*aggs)
            aggregation(name, options)
        end

        AggregationMethods.register!(:filters)

      end
    end
  end
end