module Stretchy
  module Relations
    module QueryMethods
      module Agentic
        extend ActiveSupport::Concern
        # Searches with a natural language question that an agent translates into a query.
        #
        # Agentic search needs a search pipeline with the `agentic_query_translator` request
        # processor, pointing at an agent registered with the `QueryPlanningTool`. Pick it per query
        # with `search_pipeline` or for the index with `default_search_pipeline`.
        #
        # ### Parameters
        #
        # - `query_text:` The String question to answer.
        # - `opts:` The Hash options (default: {}):
        #     - `:query_fields:` The Array of fields the agent should search (optional).
        #     - `:memory_id:` The String id of a conversation memory to continue (optional).
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the agentic query applied. A later call replaces an earlier one.
        #
        # ---
        #
        # ### Examples
        #
        # ```ruby
        #   class AgenticPipeline < Stretchy::SearchPipeline
        #     request_processor :agentic_query_translator, agent: :product_search_agent
        #   end
        #
        #   Product.search_pipeline(:agentic_pipeline).agentic("red shoes under $50", query_fields: [:name, :description])
        # ```
        #
        # See https://docs.opensearch.org/latest/vector-search/ai-search/agentic-search/index/
        def agentic(query_text, opts = {})
          spawn.agentic!(query_text, opts)
        end

        def agentic!(query_text, opts = {}) # :nodoc:
          clause = { query_text: query_text, memory_id: opts[:memory_id] }
          clause[:query_fields] = Array(opts[:query_fields]).map(&:to_s) if opts[:query_fields]
          self.agentic_values = [clause.compact]
          self
        end

        QueryMethods.register!(:agentic)
      end
    end
  end
end
