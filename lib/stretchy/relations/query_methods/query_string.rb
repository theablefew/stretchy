module Stretchy
  module Relations
    module QueryMethods
      module QueryString
        extend ActiveSupport::Concern
        # Adds a query string to the search.
        #
        # The query string uses Elasticsearch's Query String Query syntax, which includes a series of terms and operators.
        # Terms can be single words or phrases. Operators include AND, OR, and NOT, among others.
        # Field names can be included in the query string to search for specific values in specific fields. (e.g. "eye_color: green")
        # The default operator between terms are treated as OR operators.
        #
        # @param query [String] the query string
        # @param rest [Array] additional arguments (not normally used)
        #
        # @example
        #   Model.query_string("((big cat) OR (domestic cat)) AND NOT panther eye_color: green")
        #
        # @return [Stretchy::Relation] a new relation, which reflects the query string
        def query_string(opts = :chain, *rest)
          if opts == :chain
            WhereChain.new(spawn)
          elsif opts.blank?
            self
          else
            spawn.query_string!(opts, *rest)
          end
        end

        def query_string!(opts, *rest) # :nodoc:
          if opts == :chain
            WhereChain.new(self)
          else
            self.query_string_values += build_where(opts, rest)
            self
          end
        end

        QueryMethods.register!(:query_string)

      end
    end
  end
end
