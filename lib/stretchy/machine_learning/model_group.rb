module Stretchy
  module MachineLearning
    # A model group in ML Commons, which models register into and which controls access to them.
    #
    # ```ruby
    #   class Embeddings < Stretchy::MachineLearning::ModelGroup
    #     description "Sentence embedding models"
    #     access_mode "public"
    #   end
    #
    #   Embeddings.register!
    #
    #   class MyModel < Stretchy::MachineLearning::Model
    #     model_group :embeddings
    #   end
    # ```
    class ModelGroup
      include Resource

      self.registry_type = 'model_group'

      settings :description, :access_mode

      class << self
        include Errors

        def group_id
          remote_id
        end

        def register!
          response = client.register_model_group(body: to_hash)
          self.remote_id = response['model_group_id']
        end

        def find
          raise ModelGroupMissingError if group_id.blank?
          client.get_model_group(model_group_id: group_id)
        rescue Stretchy.configuration.backend.not_found_error
          raise ModelGroupMissingError
        end

        def exists?
          find.present?
        rescue ModelGroupMissingError
          false
        end

        # Deletes the remote model group, then forgets it in the registry.
        def delete!
          response = client.delete_model_group(model_group_id: group_id)
          registry.delete
          reset_remote_id!
          response
        rescue Stretchy.configuration.backend.not_found_error
          raise ModelGroupMissingError
        end

        def to_hash
          {
            name: remote_name,
            description: description,
            access_mode: access_mode
          }.compact
        end
      end
    end
  end
end
