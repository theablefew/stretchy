module Stretchy
  module MachineLearning
    class Connector
      include Resource

      self.registry_type = 'connector'

      settings :description, :version, :protocol, :credentials, :parameters, :actions

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
            response = client.create_connector(body: to_hash.as_json).with_indifferent_access
            self.remote_id = response['connector_id']
          end

          # Deletes the remote connector, then forgets it in the registry.
          def delete!
            response = client.delete_connector(connector_id: id).with_indifferent_access
            if response['result'] == 'deleted'
              registry.delete
              reset_remote_id!
            end
            response
          rescue Stretchy.configuration.backend.not_found_error
            raise ConnectorMissingError
          end

          def update!
            client.update_connector(connector_id: id, body: to_hash.as_json)
          end

          def find(connector_id = id)
            raise ConnectorMissingError if connector_id.blank?
            client.get_connector(connector_id: connector_id)
          rescue Stretchy.configuration.backend.not_found_error
            raise ConnectorMissingError
          end

          def exists?
            find.present?
          rescue ConnectorMissingError
            false
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