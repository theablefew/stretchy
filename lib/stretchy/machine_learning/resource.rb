module Stretchy
  module MachineLearning
    # Shared behavior for ML Commons resources such as models and connectors: class-level
    # settings, and the remote id the cluster assigned, remembered in the Registry.
    #
    # ```ruby
    #   class Connector
    #     include Stretchy::MachineLearning::Resource
    #     self.registry_type = 'connector'
    #     settings :description, :version
    #   end
    #
    #   class BedrockConnector < Connector
    #     description "Claude on Bedrock"
    #   end
    #
    #   BedrockConnector.description # => "Claude on Bedrock"
    #   BedrockConnector.remote_id   # => the connector id from the registry
    # ```
    module Resource
      extend ActiveSupport::Concern

      included do
        class_attribute :registry_type, instance_writer: false
        class_attribute :missing_error, instance_writer: false, default: Errors::ResourceMissingError
      end

      class_methods do
        # Declares settings, each with a class method that sets a value when given one
        # (or a block for nested settings) and reads it otherwise. Returns the values.
        def settings(*names)
          names.each { |name| define_setting(name) }
          @settings ||= Settings.new
        end

        # The ML Commons API of the configured OpenSearch client.
        def client
          Stretchy.configuration.client.ml
        end

        # The name sent to the cluster, defaulting to the underscored class name.
        def remote_name(value = nil)
          settings[:remote_name] = value if value
          settings[:remote_name] || to_s.demodulize.underscore
        end

        def registry
          @registry ||= Registry.register(class_name: name, class_type: registry_type)
        end

        def remote_id
          @remote_id || registry.remote_id
        end

        def remote_id=(id)
          registry.update(remote_id: id)
          @remote_id = id
        end

        # The remote id for a reference to another resource: a class or class name such as
        # `:embedding_model` resolves to that resource's remote id, and a String is used as given.
        def remote_id_for(reference)
          case reference
          when Class then reference.remote_id
          when Symbol then reference.to_s.camelize.constantize.remote_id
          else reference
          end
        end

        # Fetches the resource from the cluster, e.g. `get_agent(agent_id: remote_id)`.
        def find
          raise missing_error if remote_id.blank?
          client.public_send("get_#{registry_type}", **remote_id_argument)
        rescue Stretchy.configuration.backend.not_found_error
          raise missing_error
        end

        def exists?
          find.present?
        rescue missing_error
          false
        end

        # Deletes the resource from the cluster, then forgets it in the registry.
        def delete!
          response = client.public_send("delete_#{registry_type}", **remote_id_argument)
          registry.delete
          reset_remote_id!
          response
        rescue Stretchy.configuration.backend.not_found_error
          raise missing_error
        end

        def reset_remote_id!
          @remote_id = nil
          @registry = nil
        end

        private

        def remote_id_argument
          { "#{registry_type}_id": remote_id }
        end

        def define_setting(name)
          setting_methods.send(:define_method, name) do |value = nil, &block|
            if block
              settings[name] = Settings.new.tap { |nested| nested.instance_eval(&block) }
            elsif value.nil?
              settings[name]
            else
              settings[name] = value
            end
          end
        end

        def setting_methods
          @setting_methods ||= Module.new.tap { |methods| extend methods }
        end
      end
    end
  end
end
