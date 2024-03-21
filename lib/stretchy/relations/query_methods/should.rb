module Stretchy
  module Relations
    module QueryMethods
      module Should
        extend ActiveSupport::Concern
        # Adds optional conditions to the query.
        #
        # Each argument is a hash where the key is the attribute to filter by and the value is the value to match optionally.
        #
        # @overload should(*rest)
        #   @param rest [Array<Hash>] additional keywords containing attribute-value pairs to match optionally
        #
        # @example
        #   Model.should(color: :pink, size: :medium)
        #
        # @return [Stretchy::Relation] a new relation, which reflects the optional conditions
        def should(opts = :chain, *rest)
          if opts == :chain
            WhereChain.new(spawn)
          elsif opts.blank?
            self
          else
            spawn.should!(opts, *rest)
          end
        end

        def should!(opts, *rest) # :nodoc:
          if opts == :chain
            WhereChain.new(self)
          else
            self.should_values += build_where(opts, rest)
            self
          end
        end

        QueryMethods.register!(:should)

      end
    end
  end
end