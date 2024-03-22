module Stretchy
  module Relations
    module QueryMethods
      module MustNot
        extend ActiveSupport::Concern
        # Adds negated conditions to the query.
        #
        # Each argument is a keyword where the key is the attribute name and the value is the value to exclude.
        # This method acts as a convenience method for adding negated conditions to the query. It can also be used to add
        # range, regex, terms, and id queries through shorthand parameters.
        #
        # ### Parameters:
        # - `opts:` The keywords containing attribute-value pairs for conditions.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified conditions excluded.
        #
        # ---
        #
        # ### Examples
        #
        # #### Exclude multiple conditions
        # ```ruby
        #   Model.must_not(color: 'blue', size: :large)
        # ```
        #
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
