module Stretchy
  module Relations
    module QueryMethods
      module MustNot
        extend ActiveSupport::Concern
        # Adds negated conditions to the query.
        #
        # Each argument is a hash where the key is the attribute to filter by and the value is the value to exclude.
        #
        # @overload must_not(*rest)
        #   @param rest [Array<Hash>] a hash containing attribute-value pairs to exclude
        #
        # @example
        #   Model.must_not(color: 'blue', size: :large)
        #
        # @return [Stretchy::Relation] a new relation, which reflects the negated conditions
        # @see #where_not
        def must_not(opts = :chain, *rest)
          if opts == :chain
            WhereChain.new(spawn)
          elsif opts.blank?
            self
          else
            spawn.must_not!(opts, *rest)
          end
        end


        def must_not!(opts, *rest) # :nodoc:
          if opts == :chain
            WhereChain.new(self)
          else
            self.must_not_values += build_where(opts, rest)
            self
          end
        end
        
        # Alias for {#must_not}
        # @see #must_not
        alias :where_not :must_not
        QueryMethods.register!(:where_not, :must_not)
      end
    end
  end
end
