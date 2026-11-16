module Stretchy
  # An ingest pipeline, which transforms documents as they are indexed.
  #
  # ```ruby
  #   class SparseEncodingPipeline < Stretchy::IngestPipeline
  #     description "Encodes the body for neural sparse search"
  #     processor :sparse_encoding, model: :sparse_model, field_map: { body: :embedding }
  #   end
  #
  #   SparseEncodingPipeline.create!
  # ```
  #
  # See https://docs.opensearch.org/latest/ingest-pipelines/
  class IngestPipeline < Pipelines::Base
    self.processor_kinds = [:processors]
    self.api_methods = { get: :get_pipeline, put: :put_pipeline, delete: :delete_pipeline }

    abstract!

    class << self
      def client
        Stretchy.configuration.client.ingest
      end

      def processor(type, options = {})
        add_processor(:processors, type, options)
      end

      def processors
        processors_for(:processors)
      end

      def simulate(docs, verbose: true)
        client.simulate(id: pipeline_name, body: { docs: docs }, verbose: verbose)
      end
    end

    delegate :processors, :simulate, to: :class
  end
end
