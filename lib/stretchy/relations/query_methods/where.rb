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
        #   Model.where(price: 10, color: :green)
        # ```
        #
        # #### Range
        # ```ruby
        #   Model.where(price: {gte: 10, lte: 20})
        # ```
        #
        # ```ruby
        #   Model.where(age: 19..33)
        # ```
        #
        # #### Regular Expressions
        # ```ruby
        #   Model.where(color: /gr(a|e)y/)
        # ```
        #
        # #### IDs
        # ```ruby
        #   Model.where(id: [10, 22, 18])
        # ```
        # 
        # #### Terms
        # ```ruby
        #   Model.where(names: ['John', 'Jane'])
        # ```
        #
        def where(opts = :chain, *rest)
          if opts == :chain
            WhereChain.new(spawn)
          elsif opts.blank?
            self
          else
            opts.each do |key, value|
              case value
              when Range
                range = opts.delete(key)
                range_options = {gte: range.begin}
                upper_bound = range.exclude_end? ? :lt : :lte
                range_options[upper_bound] = range.end
                filter_query(:range, key => range_options)
              when Hash
                hash = opts.delete(key)
                spawn.where!(key => hash) if [:match, :match_phrase, :match_phrase_prefix].include?(key)

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
