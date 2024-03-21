module Stretchy
  module Relations
    module QueryMethods
      module NeuralSparse
        extend ActiveSupport::Concern
        # Public: Perform a neural sparse search on a specific field.
        #
        # The `neural_sparse` method accepts a Hash with the `field_name`, `model_id`, and `max_token_score` keys.
        #
        # opts - The Hash options used to refine the selection (default: {}):
        #        :field_name - The keyword argument representing the passage to be embedded and the value to be searched.
        #        :model_id - The String representing the ID of the model to be used.
        #        :max_token_score - The Integer representing the maximum token score to consider.
        #
        # Examples
        #
        #   Model.neural_sparse(passage_embedding: 'hello world', model_id: '1234', max_token_score: 2)
        #
        # Returns a new relation with the neural sparse search applied.
        def neural_sparse(opts)
          spawn.neural_sparse!(opts)
        end

        def neural_sparse!(opts) # :nodoc:
          self.neural_sparse_values += [opts]
          self
        end

        QueryMethods.register!(:neural_sparse)
      end
    end
  end
end