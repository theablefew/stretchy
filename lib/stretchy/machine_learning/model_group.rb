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
      self.missing_error = Errors::ModelGroupMissingError

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
