module Stretchy
  module Relations
    module AggregationMethods
      module Aggregation
        # Adds an aggregation to the query.
        #
        # This method is used to add an aggregation to the query. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional block to further configure the aggregation.
        #
        # ### Parameters
        #
        # - `name:` The Symbol or String representing the name of the aggregation.
        # - `options:` The Hash representing the options for the aggregation (default: {}).
        #     - `:field:` The Symbol or String representing the field to aggregate on.
        #     - `:ranges:` The Array of Hashes representing the ranges for a range aggregation.
        # - `block:` The Proc representing an optional block to further configure the aggregation.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified aggregation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Single aggregation
        #
        # ```ruby
        #   Model.aggregation(:avg_price, field: :price)
        # ```
        #
        # #### Aggregation with ranges
        #
        # ```ruby
        #   Model.aggregation(:price_ranges) do
        #     range field: :price, ranges: [{to: 100}, {from: 100, to: 200}, {from: 200}]
        #   end
        # ```
        #
        # Aggregation results are available in the `aggregations` method of the results under the name provided in the aggregation.
        #
        # ```ruby
        #   results = Model.where(color: :blue).aggregation(:avg_price, field: :price)
        #   results.aggregations.avg_price
        # ```
        #
        def aggregation(name, options = {}, &block)
            spawn.aggregation!(name, options, &block)
        end

        def aggregation!(name, options = {}, &block) # :nodoc:
            self.aggregation_values += [{name: name, args: assume_keyword_field(options)}]
            self
        end

        AggregationMethods.register!(:aggregation)

      end
    end
  end
end
