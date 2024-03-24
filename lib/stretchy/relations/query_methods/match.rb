module Stretchy
  module Relations
    module QueryMethods
      module Match

        # Adds conditions to the query.
        #
        # Each argument is a keyword where the key is the attribute name and the value is the value to match.
        # This method acts as a convenience method for adding conditions to the query. It can also be used to add
        # range, regex, terms, and id queries through shorthand parameters.
        #
        # ### Parameters
        # - `opts:` The keywords containing attribute-value pairs for conditions.
        #
        # ### Returns
        # Returns a Stretchy::Relation with the specified conditions applied.
        #
        # ---
        #
        # ### Examples
        #
        # #### Multiple Conditions
        # ```ruby
        #   Model.match(path: "/new/things", color: :green)
        # ```
        #
        def match(opts = :chain, *rest)
          if opts == :chain
            MatchChain.new(spawn)
          elsif opts.blank?
            self
          else
            spawn.match!(opts, *rest)
          end
        end

        def match!(opts, *rest) # :nodoc:
          self.match_values += opts
          self
        end

        QueryMethods.register!(:match)

      end
    end
  end
end
