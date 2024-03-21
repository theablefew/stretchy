module Stretchy
  module Relations
    module QueryMethods
      module Neural
        extend ActiveSupport::Concern
        # Public: Perform a neural search on a specific field.
        #
        # The `neural` method accepts a Hash with the field name as the key and the query text as the value.
        # It can also accept a Hash with `query_text` and `query_image` keys for multimodal neural search.
        #
        # field - The Symbol or String representing the field name.
        # opts  - The Hash options used to refine the selection (default: {}):
        #         :query_text - The String representing the query text (optional).
        #         :query_image - The String representing the base-64 encoded query image (optional).
        #         :model_id - The String representing the ID of the model to be used (required if default model ID is not set).
        #         :k - The Integer representing the number of results to return (optional, default: 10).
        #         :filter - The Object representing a query to reduce the number of documents considered (optional).
        #
        # Examples
        #
        #   Model.neural(body_embeddings: 'hello world', model_id: '1234')
        #   Model.neural(body_embeddings: {
        #     query_text: 'hello world',
        #     query_image: 'base64encodedimage'
        #   }, model_id: '1234')
        #
        # Returns a new relation with the neural search applied.
        def neural(opts)
          spawn.neural!(opts)
        end

        def neural!(opts) # :nodoc:
          self.neural_values += [opts]
          self
        end

        QueryMethods.register!(:neural)
      end
    end
  end
end
