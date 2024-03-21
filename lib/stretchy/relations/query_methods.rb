module Stretchy
  module Relations
    module QueryMethods
      extend ActiveSupport::Concern

      @_registry = []

      class << self
        # Define the register! method
        def register!(*methods)
          @_registry += methods
        end
    
        # Define a method to access the registry
        def registry
          @_registry.flatten.compact.uniq
        end
      end
      # Load all the query methods
      Dir["#{File.dirname(__FILE__)}/query_methods/*.rb"].each do |file|
        basename = File.basename(file, '.rb')
        module_name = basename.split('_').collect(&:capitalize).join
        mod = const_get(module_name)
        include mod
      end

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
        :neural_sparse,
        :neural,
        :hybrid,
        :regexp,
        :ids
      ]

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

      SINGLE_VALUE_METHODS = [:size]

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

      VALID_DIRECTIONS = [:asc, :desc, :ASC, :DESC]

      def validate_order_args(args)
        args.each do |arg|
          next unless arg.is_a?(Hash)
          arg.each do |_key, value|
            raise ArgumentError, "Direction \"#{value}\" is invalid. Valid " \
                                 "directions are: #{VALID_DIRECTIONS.inspect}" unless VALID_DIRECTIONS.include?(value)
          end
        end
      end

    end
  end
end
