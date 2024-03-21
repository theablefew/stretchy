module Stretchy
  module Relations
    module QueryMethods
      module FilterQuery
        extend ActiveSupport::Concern
        # Adds a filter to the query.
        #
        # This method supports all filters supported by Elasticsearch.
        #
        # @overload filter_query(type, opts)
        #   @param type [Symbol] the type of filter to add (:range, :term, etc.)
        #   @param opts [Hash] a hash containing the attribute and value to filter by
        #
        # @example
        #   Model.filter_query(:range, age: {gte: 30})
        #   Model.filter_query(:term, color: :blue)
        #
        # @return [Stretchy::Relation] a new relation, which reflects the filter
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
