module Stretchy
  module Relations
    module QueryMethods
      extend ActiveSupport::Concern


       MULTI_VALUE_METHODS = [
        :where,
        :order, 
        :field,
        :highlight,
        :source,
        :must_not,
        :should,
        :query_string,
        :aggregation,
        :search_option,
        :filter_query, 
        :or_filter,
        :extending,
        :skip_callbacks,
        :regexp
      ]

      SINGLE_VALUE_METHODS = [:size]

      class WhereChain
        def initialize(scope)
          @scope = scope
        end
      end


      MULTI_VALUE_METHODS.each do |name|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{name}_values                   # def select_values
            @values[:#{name}] || []            #   @values[:select] || []
          end                                  # end
                                               #
          def #{name}_values=(values)          # def select_values=(values)
            raise ImmutableRelation if @loaded #   raise ImmutableRelation if @loaded
            @values[:#{name}] = values         #   @values[:select] = values
          end                                  # end
        CODE
      end

      SINGLE_VALUE_METHODS.each do |name|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{name}_value                    # def readonly_value
            @values[:#{name}]                  #   @values[:readonly]
          end                                  # end
        CODE
      end

      SINGLE_VALUE_METHODS.each do |name|
        class_eval <<-CODE, __FILE__, __LINE__ + 1
          def #{name}_value=(value)            # def readonly_value=(value)
            raise ImmutableRelation if @loaded #   raise ImmutableRelation if @loaded
            @values[:#{name}] = value          #   @values[:readonly] = value
          end                                  # end
        CODE
      end


      # Allows you to add one or more sorts on specified fields.
      #
      # @overload order(attribute: direction, ...)
      #   @param attribute [Symbol] the attribute to sort by
      #   @param direction [Symbol] the direction to sort in (:asc or :desc)
      #
      # @overload order(attribute: {order: direction, mode: mode, ...}, ...)
      #   @param params [Hash] attributes to sort by
      #   @param params [Symbol] :attribute the attribute name as key to sort by
      #   @param options [Hash]  a hash containing possible sorting options 
      #   @option options [Symbol] :order the direction to sort in (:asc or :desc)
      #   @option options [Symbol] :mode the mode to use for sorting (:avg, :min, :max, :sum, :median)
      #   @option options [Symbol] :numeric_type the numeric type to use for sorting (:double, :long, :date, :date_nanos) 
      #   @option options [Symbol] :missing the value to use for documents without the field
      #   @option options [Hash] :nested the nested sorting options
      #   @option nested [String] :path the path to the nested object
      #   @option nested [Hash] :filter the filter to apply to the nested object
      #   @option nested [Hash] :max_children the maximum number of children to consider per root document when picking the sort value. Defaults to unlimited
      #
      # @example
      #   Model.order(created_at: :asc)
      #     # Elasticsearch equivalent
      #     #=> "sort" : [{"created_at" : "asc"}]
      #
      #   Model.order(age: :desc, name: :asc, price: {order: :desc, mode: :avg})
      #
      #     # Elasticsearch equivalent
      #     #=> "sort" : [
      #         { "price" : {"order" : "desc", "mode": "avg"}},
      #         { "name" : "asc" },
      #         { "age" : "desc" }
      #       ]
      #
      # @return [Stretchy::Relation] a new relation with the specified order
      # @see #sort
      def order(*args)
        check_if_method_has_arguments!(:order, args)
        spawn.order!(*args)
      end

      def order!(*args) # :nodoc:
        self.order_values += args.first.zip.map(&:to_h)
        self
      end

      # Alias for {#order}
      # @see #order
      alias :sort :order


      # Allows you to skip callbacks for the specified fields that are added by query_must_have for 
      # the current query.
      #
      # @example
      #  Model.skip_callbacks(:routing)
      def skip_callbacks(*args)
        spawn.skip_callbacks!(*args)
      end

      def skip_callbacks!(*args) # :nodoc:
        self.skip_callbacks_values += args
        self
      end

      alias :sort :order


      # Sets the maximum number of records to be retrieved.
      #
      # @param args [Integer] the maximum number of records to retrieve
      #
      # @example
      #   Model.size(10)
      #
      # @return [ActiveRecord::Relation] a new relation, which reflects the limit
      # @see #limit
      def size(args)
        spawn.size!(args)
      end

      def size!(args) # :nodoc:
        self.size_value = args
        self
      end

      # Alias for {#size}
      # @see #size
      alias :limit :size




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
          puts "opts: #{opts} rest: #{rest}"
        if opts == :chain
          WhereChain.new(spawn)
        elsif opts.blank?
          self
        else
          opts.each do |key, value|
            case value
            when Range
              between(value, key)
            when Hash
              filter_query(:range, key => value) if value.keys.any? { |k| [:gte, :lte, :gt, :lt].include?(k) }
            when Regexp
              regexp(Hash[key, value])
            when Array
              # handle ID queries
              # if [:id, :_id].include?(key)

              # else
                spawn.where!(opts, *rest)
              # end
            else
              spawn.where!(opts, *rest)
            end
          end

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




      # @deprecated in elasticsearch 7.x+ use {#filter_query} instead
      def or_filter(name, options = {}, &block)
        spawn.or_filter!(name, options, &block)
      end

      def or_filter!(name, options = {}, &block) # :nodoc:
        self.or_filter_values += [{name: name, args: options}]
        self
      end

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








      def field(*args)
        spawn.field!(*args)
      end
      alias :fields :field

      def field!(*args) # :nodoc:
        self.field_values += args
        self
      end



      # Controls which fields of the source are returned.
      #
      # This method supports source filtering, which allows you to include or exclude fields from the source. 
      # You can specify fields directly, use wildcard patterns, or use an object containing arrays 
      # of includes and excludes patterns.
      #
      # If the includes property is specified, only source fields that match one of its patterns are returned. 
      # You can exclude fields from this subset using the excludes property.
      #
      # If the includes property is not specified, the entire document source is returned, excluding any 
      # fields that match a pattern in the excludes property.
      #
      # @overload source(opts)
      #   @param opts [Hash, Boolean] a hash containing :includes and/or :excludes arrays, or a boolean indicating whether 
      #                               to include the source
      #
      # @example
      #   Model.source(includes: [:name, :email])
      #   Model.source(excludes: [:name, :email])
      #   Model.source(false) # don't include source
      #
      # @return [Stretchy::Relation] a new relation, which reflects the source filtering
      def source(*args)
        spawn.source!(*args)
      end

      def source!(*args) # :nodoc:
        self.source_values += args
        self
      end



      # Checks if a field exists in the documents.
      #
      # This is a helper for the exists filter in Elasticsearch, which returns documents 
      # that have at least one non-null value in the specified field.
      #
      # @param field [Symbol, String] the field to check for existence
      #
      # @example
      #   Model.has_field(:name)
      #
      # @return [ActiveRecord::Relation] a new relation, which reflects the exists filter
      def has_field(field)
        spawn.filter_query(:exists, {field: field})
      end




      def bind(value)
        spawn.bind!(value)
      end

      def bind!(value) # :nodoc:
        self.bind_values += [value]
        self
      end





      # Highlights the specified fields in the search results.
      #
      # @example
      #   Model.where(body: "turkey").highlight(:body)
      #
      # @param [Hash] args The fields to highlight. Each field is a key in the hash,
      #   and the value is another hash specifying the type of highlighting.
      #   For example, `{body: {type: :plain}}` will highlight the 'body' field
      #   with plain type highlighting.
      #
      # @return [Stretchy::Relation] Returns a Stretchy::Relation object, which can be used
      #   for chaining further query methods.
      def highlight(*args)
        spawn.highlight!(*args)
      end

      def highlight!(*args) # :nodoc:
        self.highlight_values += args
        self
      end


      # Returns a chainable relation with zero records.
      def none
        extending(NullRelation)
      end

      def none! # :nodoc:
        extending!(NullRelation)
      end


      def extending(*modules, &block)
        if modules.any? || block
          spawn.extending!(*modules, &block)
        else
          self
        end
      end

      def extending!(*modules, &block) # :nodoc:
        modules << Module.new(&block) if block
        modules.flatten!

        self.extending_values += modules
        extend(*extending_values) if extending_values.any?

        self
      end

      def build_where(opts, other = [])
        case opts
        when String, Array
          #TODO: Remove duplication with: /activerecord/lib/active_record/sanitization.rb:113
          values = Hash === other.first ? other.first.values : other

          values.grep(Stretchy::Relation) do |rel|
            self.bind_values += rel.bind_values
          end

          [other.empty? ? opts : ([opts] + other)]
        when Hash
          [other.empty? ? opts : ([opts] + other)]
        else
          [opts]
        end
      end

      private

      # If terms are used, we assume that the field is a keyword field
      # and append .keyword to the field name
      # {terms: {field: 'gender'}}
      # or nested aggs
      # {terms: {field: 'gender'}, aggs: {name: {terms: {field: 'position.name'}}}}
      # should be converted to
      # {terms: {field: 'gender.keyword'}, aggs: {name: {terms: {field: 'position.name.keyword'}}}}
      # {date_histogram: {field: 'created_at', interval: 'day'}}
      # TODO: There may be cases where we don't want to add .keyword to the field and there should be a way to override this
      KEYWORD_AGGREGATION_FIELDS = [:terms, :rare_terms, :significant_terms, :cardinality, :string_stats]
      def assume_keyword_field(args={}, parent_match=false)
        if args.is_a?(Hash)
          args.each do |k, v|
            if v.is_a?(Hash) 
              assume_keyword_field(v, KEYWORD_AGGREGATION_FIELDS.include?(k))
            else
              next unless v.is_a?(String) || v.is_a?(Symbol)
              args[k] = ([:field, :fields].include?(k.to_sym) && v !~ /\.keyword$/ && parent_match) ? "#{v}.keyword" : v.to_s
            end
          end
        end
      end

      def check_if_method_has_arguments!(method_name, args)
        if args.blank?
          raise ArgumentError, "The method .#{method_name}() must contain arguments."
        end
      end

      VALID_DIRECTIONS = [:asc, :desc, :ASC, :DESC,
                          'asc', 'desc', 'ASC', 'DESC'] # :nodoc:

      def validate_order_args(args)
        args.each do |arg|
          next unless arg.is_a?(Hash)
          arg.each do |_key, value|
            raise ArgumentError, "Direction \"#{value}\" is invalid. Valid " \
                                 "directions are: #{VALID_DIRECTIONS.inspect}" unless VALID_DIRECTIONS.include?(value)
          end
        end
      end

      def add_relations_to_bind_values(attributes)
        if attributes.is_a?(Hash)
          attributes.each_value do |value|
            if value.is_a?(ActiveRecord::Relation)
              self.bind_values += value.bind_values
            else
              add_relations_to_bind_values(value)
            end
          end
        end
      end
    end

    end
end
