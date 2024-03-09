module Stretchy
    # This class represents a relation to Elasticsearch documents.
    # It provides methods for querying and manipulating the documents.
    class Relation

        # These methods can accept multiple values.
        MULTI_VALUE_METHODS  = [:order, :where, :or_filter, :filter_query, :bind, :extending, :unscope, :skip_callbacks]

        # These methods can accept a single value.
        SINGLE_VALUE_METHODS = [:limit, :offset, :routing, :size]

        # These methods cannot be used with the `delete_all` method.
        INVALID_METHODS_FOR_DELETE_ALL = [:limit, :offset]

        # All value methods.
        VALUE_METHODS = MULTI_VALUE_METHODS + SINGLE_VALUE_METHODS

        # Include modules.
        include Relations::FinderMethods, Relations::SpawnMethods, Relations::QueryMethods, Relations::AggregationMethods, Relations::SearchOptionMethods, Delegation

        # Getters.
        attr_reader :klass, :loaded
        alias :model :klass
        alias :loaded? :loaded

        # Delegates to the results array.
        delegate :blank?, :empty?, :any?, :many?, to: :results

        # Constructor.
        #
        # @param klass [Class] The class of the Elasticsearch documents.
        # @param values [Hash] The initial values for the relation.
        def initialize(klass, values={})
            @klass  = klass
            @values = values
            @offsets = {}
            @loaded = false
        end

        # Builds a new Elasticsearch document.
        #
        # @param args [Array] The arguments to pass to the document constructor.
        # @return [Object] The new document.
        def build(*args)
         @klass.new *args
        end

        # Returns the results of the relation as an array.
        #
        # @return [Array] The results of the relation.
        def to_a

          load
          @records
        end
        alias :results :to_a

        def response
          to_a.response
        end

        # Returns the results of the relation as a JSON object.
        #
        # @param options [Hash] The options to pass to the `as_json` method.
        # @return [Hash] The results of the relation as a JSON object.
        def as_json(options = nil)
          to_a.as_json(options)
        end

        # Returns the Elasticsearch query for the relation.
        #
        # @return [Hash] The Elasticsearch query for the relation.
        def to_elastic
          query_builder.to_elastic
        end

        # Creates a new Elasticsearch document.
        #
        # @param args [Array] The arguments to pass to the document constructor.
        # @param block [Proc] The block to pass to the document constructor.
        # @return [Object] The new document.
        def create(*args, &block)
           scoping { @klass.create!(*args, &block) }
        end

        # Executes a block of code within the scope of the relation.
        #
        # @yield The block of code to execute.
        def scoping
          previous, klass.current_scope = klass.current_scope, self
          yield
        ensure
          klass.current_scope = previous
        end

        # Loads the results of the relation.
        #
        # @return [Relation] The relation object.
        def load
          exec_queries unless loaded?

          self
        end
        alias :fetch :load

        # Deletes Elasticsearch documents.
        #
        # @param opts [Hash] The options for the delete operation.
        def delete(opts=nil)
        end

        # Executes the Elasticsearch query for the relation.
        #
        # @return [Array] The results of the query.
        def exec_queries
          # Run safety callback
          klass._circuit_breaker_callbacks.each do |cb|
            current_scope_values = self.send("#{cb[:options][:in]}_values")
            next if skip_callbacks_values.include? cb[:name]
            valid = if cb[:callback].nil?
              current_scope_values.collect(&:keys).flatten.include? cb[:name]
            else
              cb[:callback].call(current_scope_values.collect(&:keys).flatten, current_scope_values)
            end

            raise Stretchy::Errors::QueryOptionMissing, "#{cb[:name]} #{cb[:options][:message]}" unless valid
          end

          @records = @klass.fetch_results(query_builder)

          @loaded = true
          @records
        end

        # Returns the values of the relation as a hash.
        #
        # @return [Hash] The values of the relation.
        def values
          Hash[@values]
        end

        # Returns a string representation of the relation.
        #
        # @return [String] The string representation of the relation.
        def inspect
          begin
            entries = to_a.results.take([size_value.to_i + 1, 11].compact.min).map!(&:inspect)
            message = {}
            message = {total: to_a.total, max: to_a.total}
            message.merge!(aggregations: results.response.aggregations.keys) unless results.response.aggregations.nil?
            message = message.each_pair.collect { |k,v|  "#{k}: #{v}" }
            message.unshift entries.join(', ') unless entries.size.zero?
            "#<#{self.class.name} #{message.join(', ')}>"
          rescue StandardError => e
            e
          end
        end

        private

        # Returns the query builder for the relation.
        #
        # @return [QueryBuilder] The query builder for the relation.
        def query_builder
          Relations::QueryBuilder.new(values)
        end

    end
  end
