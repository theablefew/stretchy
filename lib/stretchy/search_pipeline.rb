module Stretchy
  # A search pipeline, which transforms search requests, responses and the results passed
  # between search phases. OpenSearch only.
  #
  # ```ruby
  #   class RagPipeline < Stretchy::SearchPipeline
  #     response_processor :retrieval_augmented_generation, model: :claude_model, context_field_list: [:body]
  #   end
  #
  #   RagPipeline.create! # PUT /_search/pipeline/rag_pipeline
  # ```
  #
  # See https://docs.opensearch.org/latest/search-plugins/search-pipelines/index/
  class SearchPipeline < Pipelines::Base
    self.processor_kinds = [:request_processors, :response_processors, :phase_results_processors]
    self.api_methods = { get: :get, put: :put, delete: :delete }

    abstract!

    class << self
      def client
        Stretchy.configuration.client.search_pipeline
      end

      def available?
        Stretchy.configuration.opensearch?
      end

      def request_processor(type, options = {})
        add_processor(:request_processors, type, options)
      end

      def response_processor(type, options = {})
        add_processor(:response_processors, type, options)
      end

      def phase_results_processor(type, options = {})
        add_processor(:phase_results_processors, type, options)
      end

      def to_hash
        super.select { |_kind, value| value.present? }
      end
    end
  end
end
