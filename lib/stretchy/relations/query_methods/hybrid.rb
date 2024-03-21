module Stretchy
  module Relations
    module QueryMethods
      module Hybrid
        extend ActiveSupport::Concern
        # Public: Perform a hybrid search using both neural and traditional queries.
        #
        # The `hybrid` method accepts two parameters: `neural` and `query`, both of which are arrays.
        # The `neural` array should contain hashes representing neural queries, with each hash containing
        # The `query` array should contain hashes representing traditional queries.
        #
        # opts - The Hash options used to refine the selection (default: {}):
        #        :neural - The Array of neural queries (default: []).
        #        :query - The Array of traditional queries (default: []).
        #                 Each element is a Hash representing a traditional query.
        #
        # Examples
        #
        #   Model.hybrid(
        #     neural: [
        #      {
        #         passage_embedding: 'hello world', 
        #         model_id: '1234', 
        #         k: 2
        #      }
        #     ], 
        #     query: [
        #       {
        #         term: {
        #           status: :active
        #           }
        #         }
        #       ]
        #     )
        #
        # Returns a new relation with the hybrid search applied.
        def hybrid(opts)
          spawn.hybrid!(opts)
        end

        def hybrid!(opts) # :nodoc:
          self.hybrid_values += [opts]
          self
        end

        QueryMethods.register!(:hybrid)
      end
    end
  end
end