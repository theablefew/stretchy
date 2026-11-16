module Stretchy
  module Pipelines
    # Shared behavior for ingest and search pipelines: a name, a description, processors
    # grouped by kind, and create!, find, exists? and delete! against the cluster.
    #
    # Subclasses set `processor_kinds`, the body keys holding their processors, and
    # `api_methods`, the client methods that get, put and delete them.
    class Base
      class_attribute :processor_kinds, instance_writer: false, default: []
      class_attribute :api_methods, instance_writer: false, default: {}

      class << self
        # Marks a class as a base for other pipelines, leaving it out of the rake tasks.
        def abstract!
          @abstract = true
        end

        def abstract?
          @abstract == true
        end

        # Whether the configured backend supports this kind of pipeline.
        def available?
          true
        end

        def pipeline_name(name = nil)
          @pipeline_name = name.to_s if name
          @pipeline_name || self.name.split('::').last.underscore
        end

        def description(description = nil)
          @description = description if description
          @description
        end

        def processors_for(kind)
          @processors ||= {}
          @processors[kind] ||= []
        end

        def all
          client.public_send(api_methods[:get])
        rescue not_found
          {}
        end

        def find(id = pipeline_name)
          client.public_send(api_methods[:get], id: id)
        end

        def create!
          client.public_send(api_methods[:put], id: pipeline_name, body: to_hash)
        end

        def delete!
          client.public_send(api_methods[:delete], id: pipeline_name)
        end

        def exists?
          find.present?
        rescue not_found
          false
        end

        def to_hash
          processor_kinds.each_with_object({ description: description }) do |kind, body|
            body[kind] = processors_for(kind).map(&:to_hash)
          end.as_json
        end

        protected

        def add_processor(kind, type, options)
          processors_for(kind) << Processor.new(type, options)
        end

        def not_found
          Stretchy.configuration.backend.not_found_error
        end
      end

      abstract!

      delegate :pipeline_name, :description, :find, :exists?, :to_hash, :client, to: :class
    end
  end
end
