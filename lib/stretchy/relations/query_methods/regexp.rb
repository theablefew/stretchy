module Stretchy
  module Relations
    module QueryMethods
      module Regexp
        extend ActiveSupport::Concern
        # Adds a regexp condition to the query.
        # 
        # @param field [Hash] the field to filter by and the Regexp to match
        # @param opts [Hash] additional options for the regexp query
        #     - :flags [String] the flags to use for the regexp query (e.g. 'ALL')
        #     - :use_keyword [Boolean] whether to use the .keyword field for the regexp query. Default: true
        #     - :case_insensitive [Boolean] whether to use case insensitive matching. If the regexp has ignore case flag `/regex/i`, this is automatically set to true
        #     - :max_determinized_states [Integer] the maximum number of states that the regexp query can produce
        #     - :rewrite [String] the rewrite method to use for the regexp query
        #     
        # 
        # @example
        #  Model.regexp(:name, /john|jane/)
        #  Model.regexp(:name, /john|jane/i)
        #  Model.regexp(:name, /john|jane/i, flags: 'ALL')
        #  
        # @return [Stretchy::Relation] a new relation, which reflects the regexp condition
        # @see #where
        def regexp(args)
          spawn.regexp!(args)
        end

        def regexp!(args) # :nodoc:
          args = args.to_a
          target_field, regex = args.shift
          opts = args.to_h
          opts.reverse_merge!(use_keyword: true)
          target_field = "#{target_field}.keyword" if opts.delete(:use_keyword)
          opts.merge!(case_insensitive: true) if regex.casefold?
          self.regexp_values += [[Hash[target_field, regex.source], opts]]
          self
        end
  
        QueryMethods.register!(:regexp)
  
      end
    end
  end
end
