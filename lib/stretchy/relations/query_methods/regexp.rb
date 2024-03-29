module Stretchy
  module Relations
    module QueryMethods
      module Regexp
        extend ActiveSupport::Concern
        # Adds a regexp condition to the query.
        #
        # This method is used to filter the results of a query based on a regular expression. It accepts a hash where the key is the field name and the value is the regular expression.
        #
        # ### Parameters
        #
        # - `field:` The Symbol or String representing the field name as the key and the regular expression to be matched as value.
        # - `opts:` The keywords representing additional options for the regexp query (optional).
        #     - `flags:` The String representing the flags to use for the regexp query (e.g. 'ALL').
        #     - `use_keyword:` The Boolean indicating whether to use the .keyword field for the regexp query (default: true).
        #     - `case_insensitive:` The Boolean indicating whether to use case insensitive matching. If the regexp has ignore case flag `/regex/i`, this is automatically set to true.
        #     - `max_determinized_states:` The Integer representing the maximum number of states that the regexp query can produce.
        #     - `rewrite:` The String representing the rewrite method to use for the regexp query.
        #
        # ### Returns
        # Returns a new Stretchy::Relation, which reflects the regexp condition.
        #
        # ---
        #
        # ### Examples
        #
        # #### Regexp condition
        #
        # ```ruby
        #   Model.regexp(name: /john|jane/)
        #```
        #
        # #### Regexp with case insensitive matching
        # ```ruby
        #   Model.regexp(name: /john|jane/i)
        # ```
        # 
        # #### Regexp with flags
        # ```ruby
        #   Model.regexp(name: /john|jane/i, flags: 'ALL')
        # ```
        #
        def regexp(args)
          spawn.regexp!(args)
        end

        def regexp!(args) # :nodoc:
          args = args.to_a
          target_field, regex = args.shift
          opts = args.to_h
          opts.merge!(case_insensitive: true) if regex.casefold?
          self.regexp_values += [[Hash[target_field, regex.source], opts]]
          self
        end
  
        QueryMethods.register!(:regexp)
  
      end
    end
  end
end
