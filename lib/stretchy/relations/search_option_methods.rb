module Stretchy
  module Relations

    module SearchOptionMethods
      extend ActiveSupport::Concern

      # Request parameters that take a single value, e.g. `routing('user_1')`.
      SINGLE_VALUE_OPTIONS = [:routing, :search_pipeline]

      METHODS = SINGLE_VALUE_OPTIONS + [:search_options]

      SINGLE_VALUE_OPTIONS.each do |option|
        define_method(option) do |value|
          check_if_method_has_arguments!(option, value)
          spawn.public_send(:"#{option}!", value)
        end

        define_method(:"#{option}!") do |value|
          merge_search_option_values(option, value)
          self
        end
      end

      # Runs the search through a search pipeline, given as a SearchPipeline class, its class
      # name such as `:rag_pipeline`, or a pipeline name.
      #
      # ```ruby
      #   Post.search_pipeline(:rag_pipeline).where(title: 'hello') # sends search_pipeline=rag_pipeline
      # ```
      def search_pipeline!(pipeline)
        merge_search_option_values(:search_pipeline, Stretchy::Pipelines::Base.pipeline_name_for(pipeline))
        self
      end

      def search_options(*args)
        spawn.search_options!(*args)
      end

      def search_options!(*args)
        self.search_option_values += args
        self
      end

      private

      def merge_search_option_values(key, value)
        self.search_option_values += [Hash[key,value]]
      end

    end
  end
end
