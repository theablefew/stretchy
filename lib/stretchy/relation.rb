module Stretchy
    # This class represents a relation to Elasticsearch documents.
    # It provides methods for querying and manipulating the documents.
    class Relation


        # These methods cannot be used with the `delete_all` method.
        INVALID_METHODS_FOR_DELETE_ALL = [:limit, :offset]

        # Include modules.
        include Relations::FinderMethods, 
                Relations::SpawnMethods, 
                Relations::QueryMethods, 
                Relations::AggregationMethods, 
                Relations::SearchOptionMethods, 
                Delegation

        attr_reader :klass, :loaded
        alias :model :klass
        alias :loaded? :loaded

        # Delegates to the results array.
        delegate :blank?, :empty?, :any?, :many?, to: :results

        # Initialize a new instance of the relation.
        #
        # This constructor method is used to create a new instance of the relation. It accepts a class representing the Elasticsearch documents and a hash of initial values for the relation.
        #
        # ### Parameters
        #
        # - `klass:` The Class representing the Elasticsearch documents.
        # - `values:` The Hash representing the initial values for the relation (optional).
        #
        # ### Returns
        # Returns a new instance of the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Initialize a new relation
        #
        # ```ruby
        #   relation = Relation.new(Model, {name: 'John Doe', age: 30})
        # ```
        #
        def initialize(klass, values={})
            @klass  = klass
            @values = values.merge(default_size: klass.default_size)
            @offsets = {}
            @loaded = false
        end

        # Initialize a new instance of the relation.
        #
        # This constructor method is used to create a new instance of the relation. It accepts a class representing the Elasticsearch documents and a hash of initial values for the relation.
        #
        # ### Parameters
        #
        # - `klass:` The Class representing the Elasticsearch documents.
        # - `values:` The Hash representing the initial values for the relation (optional).
        #
        # ### Returns
        # Returns a new instance of the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Initialize a new relation
        #
        # ```ruby
        #   relation = Relation.new(Model, {name: 'John Doe', age: 30})
        # ```
        #
        def build(*args)
         @klass.new *args
        end

        # Returns the results of the relation as an array.
        #
        # This instance method is used to load the results of the relation and return them as an array. It calls the `load` method to load the results and then returns the `@records` instance variable.
        #
        # ### Returns
        # Returns an Array representing the results of the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get the results of a relation as an array
        #
        # ```ruby
        #   relation = Relation.new(Model, {name: 'John Doe', age: 30})
        #   results = relation.results
        # ```
        #
        def results
          load
          @records
        end

        # _alias for `results`_
        alias :to_a :results

        # Returns the raw Elasticsearch response for the relation.
        #
        # This instance method is used to get the raw Elasticsearch response for the relation. It calls the `results` method to load the results and then returns the `response` property of the results.
        #
        # ### Returns
        # Returns a Hash representing the raw Elasticsearch response for the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get the raw Elasticsearch response for a relation
        #
        # ```ruby
        #   relation = Relation.new(Model, {name: 'John Doe', age: 30})
        #   raw_response = relation.response
        # ```
        #
        # #### With a model
        # ```ruby
        #  relation = Model.where(name: 'John Doe')
        #  raw_response = relation.response
        #  #=> {"took"=>3, "timed_out"=>false, "_shards"=>{"total"=>1, "successful"=>1, "skipped"=>0, "failed"=>0}, "hits"=>{"total"=>{"value"=>0, "relation"=>"eq"}, "max_score"=>nil, "hits"=>[]}}
        # ```
        #
        def response
          results.response
        end

        # Returns the results of the relation as a JSON object.
        #
        # This instance method is used to get the results of the relation as a JSON object. It calls the `as_json` method on the results of the relation and passes any provided options to it.
        #
        # ### Parameters
        #
        # - `options:` The Hash representing the options to pass to the `as_json` method (optional).
        #
        # ### Returns
        # Returns a Hash representing the results of the relation as a JSON object.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get the results of a relation as a JSON object
        #
        # ```ruby
        #   relation = Relation.new(Model, {name: 'John Doe', age: 30})
        #   json_results = relation.as_json
        # ```
        #
        def as_json(options = nil)
          results.as_json(options)
        end

        # Returns the Elasticsearch query for the relation.
        #
        # This instance method is used to get the Elasticsearch query for the relation. It calls the `to_elastic` method on the `query_builder` of the relation.
        #
        # ### Returns
        # Returns a Hash representing the Elasticsearch query for the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get the Elasticsearch query for a relation
        #
        # ```ruby
        #   Model.where(flight: 'goat').to_elastic
        #   #=> {"query"=>{"bool"=>{"must"=>{"term"=>{"flight.keyword"=>"goat"}}}}}
        # ```
        #
        def to_elastic
          query_builder.to_elastic
        end

        # Creates a new Elasticsearch document.
        #
        # This instance method is used to create a new Elasticsearch document within the scope of the relation. It accepts a list of arguments and an optional block to pass to the document constructor.
        #
        # ### Parameters
        #
        # - `*args:` A list of arguments to pass to the document constructor.
        # - `&block:` An optional block to pass to the document constructor.
        #
        # ### Returns
        # Returns the newly created document.
        #
        # ---
        #
        # ### Examples
        #
        # #### Create a new document within the scope of a relation
        #
        # ```ruby
        #   document = relation.create(name: 'John Doe', age: 30)
        # ```
        #
        def create(*args, &block)
           scoping { @klass.create!(*args, &block) }
        end

        # Executes a block of code within the scope of the relation.
        #
        # This instance method is used to execute a block of code within the scope of the relation. It temporarily sets the current scope of the class to this relation, executes the block, and then resets the current scope to its previous value.
        #
        # ### Parameters
        #
        # - `&block:` The block of code to execute within the scope of the relation.
        #
        # ### Returns
        # Returns the result of the block execution.
        #
        #
        def scoping
          previous, klass.current_scope = klass.current_scope, self
          yield
        ensure
          klass.current_scope = previous
        end

        # Loads the results of the relation.
        #
        # This instance method is used to load the results of the relation. It calls the `exec_queries` method to execute the queries unless the results have already been loaded.
        #
        # ### Returns
        # Returns the relation object itself.
        #
        # ---
        #
        # ### Examples
        #
        # #### Load the results of a relation
        #
        # ```ruby
        #   relation = Model.where(flight: 'goat')
        #   relation.load
        # ```
        #
        def load
          exec_queries unless loaded?
          self
        end

        # _alias for `load`_
        alias :fetch :load

        def delete(opts=nil) #:nodoc:
        end

        # Executes the Elasticsearch query for the relation.
        #
        # This instance method is used to execute the Elasticsearch query for the relation. It calls the `execute` method on the `query_builder` of the relation and stores the results in the `@records` instance variable.
        #
        # ### Returns
        # Returns an Array representing the results of the query.
        #
        #
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
        # This instance method is used to get the values of the relation as a hash. It converts the `@values` instance variable to a hash and returns it.
        #
        # ### Returns
        # Returns a Hash representing the values of the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get the values of a relation
        #
        # ```ruby
        #   relation = Model.where(flight: 'goat')
        #   values = relation.values
        # ```
        #
        def values
          Hash[@values]
        end

        #  Returns a string representation of the relation.
        #
        # This instance method is used to get a string representation of the relation. It includes information about the total number of results, the maximum number of results, and any aggregations present in the response.
        #
        # ### Returns
        # Returns a String representing the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get a string representation of a relation
        #
        # ```ruby
        #   Model.where(flight: 'goat').terms(:flights, field: :flight).inspect
        #   #=> #<Stretchy::Relation total: 0, max: 0, aggregations: ["flights"]> 
        # ```
        # 
        def inspect
          begin
            entries = to_a.results.take([size_value.to_i + 1, 11].compact.min).map!(&:inspect)
            message = {}
            message = {total: results.total, max: results.total}
            message.merge!(aggregations: response.aggregations.keys) unless response.aggregations.nil?
            message = message.each_pair.collect { |k,v|  "#{k}: #{v}" }
            message.unshift entries.join(', ') unless entries.size.zero?
            "#<#{self.class.name} #{message.join(', ')}>"
          rescue StandardError => e
            Stretchy.logger.error e.message
            raise e
          end
        end

        private

        # Returns the query builder for the relation.
        #
        # This private instance method is used to get the query builder for the relation. It creates a new instance of `Relations::QueryBuilder` with the values of the relation and the attribute types of the class.
        #
        # ### Returns
        # Returns a `Relations::QueryBuilder` representing the query builder for the relation.
        #
        # ---
        #
        # ### Examples
        #
        # #### Get the query builder for a relation
        #
        # ```ruby
        #   relation = Model.where(flight: 'goat')
        #   query_builder = relation.send(:query_builder)
        # ```
        #
        def query_builder
          Relations::QueryBuilder.new(values, klass.attribute_types)
        end

    end
  end
