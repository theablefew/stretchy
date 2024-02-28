require 'active_support/core_ext/array/wrap'

module Elasticsearch
  module Persistence
    module QueryMethods
      extend ActiveSupport::Concern


       MULTI_VALUE_METHODS = [:where, :order, :field, :highlight, :source,
                              :must_not, :should, :query_string,
                              :aggregation, :search_option,
                              :filter, :or_filter, :extending, :skip_callbacks]
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



      def order(*args)
        check_if_method_has_arguments!(:order, args)
        spawn.order!(*args)
      end

      def order!(*args)
        self.order_values += [preprocess_order_args(args)]
        self
      end

      alias :sort :order


      def skip_callbacks(*args)
        spawn.skip_callbacks!(*args)
      end

      def skip_callbacks!(*args)
        self.skip_callbacks_values += args
        self
      end

      alias :sort :order


      def size(args)
        spawn.size!(args)
      end

      def size!(args)
        self.size_value = args
        self
      end

      alias :limit :size




      def where(opts = :chain, *rest)
        if opts == :chain
          WhereChain.new(spawn)
        elsif opts.blank?
          self
        else
          spawn.where!(opts, *rest)
        end
      end

      alias :must :where

      def where!(opts, *rest) # :nodoc:
        if opts == :chain
          WhereChain.new(self)
        else
          #if Hash === opts
            #opts = sanitize_forbidden_attributes(opts)
          #end

          self.where_values += build_where(opts, rest)
          self
        end
      end




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




      def must_not(opts = :chain, *rest)
        if opts == :chain
          WhereChain.new(spawn)
        elsif opts.blank?
          self
        else
          spawn.must_not!(opts, *rest)
        end
      end

      alias :where_not :must_not

      def must_not!(opts, *rest)
        if opts == :chain
          WhereChain.new(self)
        else
          self.must_not_values += build_where(opts, rest)
          self
        end
      end




      def should(opts = :chain, *rest)
        if opts == :chain
          WhereChain.new(spawn)
        elsif opts.blank?
          self
        else
          spawn.should!(opts, *rest)
        end
      end

      def should!(opts, *rest)
        if opts == :chain
          WhereChain.new(self)
        else
          self.should_values += build_where(opts, rest)
          self
        end
      end


      def or_filter(name, options = {}, &block)
        spawn.or_filter!(name, options, &block)
      end

      def or_filter!(name, options = {}, &block)
        self.or_filter_values += [{name: name, args: options}]
        self
      end



      def filter(name, options = {}, &block)
        spawn.filter!(name, options, &block)
      end

      def filter!(name, options = {}, &block)
        self.filter_values += [{name: name, args: options}]
        self
      end




      def aggregation(name, options = {}, &block)
        spawn.aggregation!(name, options, &block)
      end

      def aggregation!(name, options = {}, &block)
        self.aggregation_values += [{name: name, args: options}]
        self
      end




      def field(*args)
        spawn.field!(*args)
      end
      alias :fields :field

      def field!(*args)
        self.field_values += args
        self
      end




      def source(*args)
        spawn.source!(*args)
      end

      def source!(*args)
        self.source_values += args
        self
      end




      def has_field?(field)
        spawn.filter(:exists, {field: field})
      end




      def bind(value)
        spawn.bind!(value)
      end

      def bind!(value) # :nodoc:
        self.bind_values += [value]
        self
      end

      def build_where(opts, other = [])
        case opts
        when String, Array
          #TODO: Remove duplication with: /activerecord/lib/active_record/sanitization.rb:113
          values = Hash === other.first ? other.first.values : other

          values.grep(Elasticsearch::Persistence::Relation) do |rel|
            self.bind_values += rel.bind_values
          end

          [other.empty? ? opts : ([opts] + other)]
        when Hash
          [other.empty? ? opts : ([opts] + other)]
        else
          [opts]
        end
      end

      def highlight(*args)
        spawn.highlight!(*args)
      end

      def highlight!(*args)
        self.highlight_values += args
        self
      end


      # Returns a chainable relation with zero records.
      #
      #
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

      private

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

      def preprocess_order_args(order_args)
        args = order_args.reject{ |arg| arg.is_a?(Hash) }.take(2)
        return [Hash[[args]]] if args.length == 2
        order_args.select { |arg| arg.is_a?(Hash)}.flatten
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
