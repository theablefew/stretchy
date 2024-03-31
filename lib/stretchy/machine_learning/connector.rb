module Stretchy
  module MachineLearning
    class Connector

      cattr_reader :client do 
        Stretchy.configuration.client.connector
      end

      class Settings
        def initialize(valid_keys = [])
          @valid_keys = valid_keys
          @settings = {}
        end

        def as_json(*)
          @settings.as_json
        end
      
        def method_missing(method, *args, &block)
          if block_given?
            @settings[method] = self.class.new.tap { |obj| obj.instance_eval(&block) }
          elsif args.empty?
            value = @settings[method]
            value.is_a?(Hash) ? Elasticsearch::Model::HashWrapper[value] : value
          elsif args.length == 1 && @valid_keys.empty? || @valid_keys.include?(method)
            @settings[method] = args.first
          else
            super
          end
        end
      
        def respond_to_missing?(method, include_private = false)
          @settings.key?(method) || super
        end
      end
      
      class << self
        include Errors
        
        METHODS = [
          :description,
          :version,
          :protocol,
          :credentials,
          :parameters,
          :actions,
          :name
        ].freeze
        
        def settings
          @settings ||= Settings.new(METHODS)
        end
    
        delegate *METHODS, to: :settings

        def name(name = nil)
          settings.name(name) if name 
          settings.name || to_s.split('::').last.underscore
        end

        def registry
          @registery ||= Stretchy::MachineLearning::Registry.register(class_name: self.name, class_type: 'connector')
        end

        def id
          @id || registry.model_id
        end

        concerning :API do
          def create!
            response = client.post(body: self.to_hash.as_json).with_indifferent_access
            registry.update(model_id: response.dig(:connector_id))
            @id = response.dig(:connector_id)
          end

          def delete!
            begin
              response = client.delete(connector_id: self.id).with_indifferent_access
            rescue "#{Stretchy.configuration.search_backend_const}::Transport::Transport::Errors::NotFound".constantize => e
              raise Stretchy::MachineLearning::Errors::ConnectorMissingError
              
            ensure
              if response.dig(:result) == 'deleted'
                registry.delete
                @registry = nil
                @id = nil
              end
              response
            end
          end

          def update!
            client.put(connector_id: self.id, body: self.to_hash)
          end

          def find(id = nil)
            begin
              id = self.id if id.nil?
              client.get(connector_id: id)
            rescue ArgumentError => e
              raise Stretchy::MachineLearning::Errors::ConnectorMissingError
            rescue "#{Stretchy.configuration.search_backend_const}::Transport::Transport::Errors::NotFound".constantize => e
              # raise Stretchy::MachineLearning::Errors::ConnectorMissingError
            end
          end

          def exists?
            self.find(self.id).present?
          end

          def to_hash
            acts = self.actions.as_json
            acts[:request_body] = actions[:request_body]
            {
              name: self.name,
              description: self.description,
              version: self.version,
              protocol: self.protocol,
              credential: self.credentials,
              parameters: self.parameters,
              actions: [acts]
            }.compact

          end
        end
     
      end
    end
  end
end