module Stretchy
  module Relations
    module QueryMethods
      module Where

        class WhereChain
          def initialize(scope)
            @scope = scope
          end
        end
        # Adds conditions to the query.
        #
        # Each argument is a hash where the key is the attribute to filter by and the value is the value to match.
        #
        # @overload where(*rest)
        #   @param rest [Array<Hash>] keywords containing attribute-value pairs to match
        #
        # @example
        #   Model.where(price: 10, color: :green)
        #
        #   # Elasticsearch equivalent
        #   # => "query" : {
        #          "bool" : {
        #            "must" : [
        #              { "term" : { "price" : 10 } },
        #              { "term" : { "color" : "green" } }
        #            ]
        #          }
        #        }
        #
        # .where acts as a convienence method for adding conditions to the query. It can also be used to add
        # range , regex, terms, and id queries through shorthand parameters.
        #
        # @example
        #   Model.where(price: {gte: 10, lte: 20})
        #   Model.where(age: 19..33)
        #   Model.where(color: /gr(a|e)y/)
        #   Model.where(id: [10, 22, 18])
        #   Model.where(names: ['John', 'Jane'])
        #
        # @return [ActiveRecord::Relation, WhereChain] a new relation, which reflects the conditions, or a WhereChain if opts is :chain
        # @see #must
        def where(opts = :chain, *rest)
          if opts == :chain
            WhereChain.new(spawn)
          elsif opts.blank?
            self
          else
            opts.each do |key, value|
              case value
              when Range
                opts.delete(key)
                between(value, key)
              when Hash
                opts.delete(key)
                filter_query(:range, key => value) if value.keys.any? { |k| [:gte, :lte, :gt, :lt].include?(k) }
              when ::Regexp
                opts.delete(key)
                regexp(Hash[key, value])
              when Array
                # handle ID queries
                if [:id, :_id].include?(key)
                  opts.delete(key)
                  ids(value)
                end
              end
            end

            spawn.where!(opts, *rest) unless opts.empty?
            self

          end
        end


        def where!(opts, *rest) # :nodoc:
          if opts == :chain
            WhereChain.new(self)
          else
            self.where_values += build_where(opts, rest)
            self
          end
        end
        
        # Alias for {#where}
        # @see #where
        alias :must :where

        QueryMethods.register!(:where, :must)

      end
    end
  end
end
