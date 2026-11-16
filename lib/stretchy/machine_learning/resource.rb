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

        def reset_remote_id!
          @remote_id = nil
          @registry = nil
        end

        private

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
