module Stretchy
  module MachineLearning
    class Connector
      include Resource

      self.registry_type = 'connector'

      settings :description, :version, :protocol, :credentials, :parameters, :actions

      cattr_reader :client do 
        Stretchy.configuration.client.connector
      end

      class << self
        include Errors

        # The connector name sent to the cluster, defaulting to the underscored class name.
        def name(name = nil)
          settings[:name] = name if name
          settings[:name] || to_s.split('::').last.underscore
        end

        def id
          remote_id
        end

        concerning :API do
          def create!
            response = client.post(body: self.to_hash.as_json).with_indifferent_access
            self.remote_id = response.dig(:connector_id)
          end

          def delete!
            begin
              response = client.delete(connector_id: self.id).with_indifferent_access
            rescue Stretchy.configuration.backend.not_found_error => e
              raise Stretchy::MachineLearning::Errors::ConnectorMissingError
              
            ensure
              if response.dig(:result) == 'deleted'
                registry.delete
                reset_remote_id!
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
            rescue Stretchy.configuration.backend.not_found_error => e
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