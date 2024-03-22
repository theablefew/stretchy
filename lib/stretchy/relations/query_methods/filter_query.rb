module Stretchy
  module Relations
    module QueryMethods
      module FilterQuery
        extend ActiveSupport::Concern

        # Adds a filter to the Elasticsearch query.
        #
        # This method is used to filter the results of a query without affecting the score. It accepts a type and a condition.
        # The type can be any valid Elasticsearch filter type, such as `:term`, `:range`, or `:bool`. The condition is a hash
        # that specifies the filter conditions.
        #
        # ### Parameters
        # - `type:` The Symbol representing the filter type.
        # - `condition:` The Hash containing the filter conditions.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified filter applied.
        #
        # ---
        #
        # ### Examples
        #
        # #### Term filter
        # ```ruby
        #   Model.filter_query(:term, color: 'blue')
        # ```
        #
        # #### Range filter
        # ```ruby
        #   Model.filter_query(:range, age: { gte: 21 })
        # ```
        #
        # #### Bool filter
        # ```ruby
        #   Model.filter_query(:bool, must: [{ term: { color: 'blue' } }, { range: { age: { gte: 21 } } }])
        # ```
        #
        def filter_query(name, options = {}, &block)
          spawn.filter_query!(name, options, &block)
        end

        def filter_query!(name, options = {}, &block) # :nodoc:
          self.filter_query_values += [{name: name, args: options}]
          self
        end

        QueryMethods.register!(:filter_query)

      end
    end
  end
end
