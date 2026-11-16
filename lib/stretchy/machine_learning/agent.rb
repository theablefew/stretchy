module Stretchy
  module MachineLearning
    # An ML Commons agent: an agent type with tools, an LLM and memory, run by the cluster.
    #
    # ```ruby
    #   class SupportAgent < Stretchy::MachineLearning::Agent
    #     agent_type :conversational_flow
    #     llm :claude_model, parameters: { max_iteration: 5 }
    #     memory :conversation_index
    #     tool :vector_db, model: :embedding_model, index: Post, embedding_field: "body_embedding"
    #     tool :ml_model, model: :claude_model, prompt: "Answer from ${parameters.VectorDBTool.output}"
    #   end
    #
    #   SupportAgent.register!
    #   SupportAgent.execute(question: "How do I reset my password?")
    # ```
    #
    # See https://docs.opensearch.org/latest/ml-commons-plugin/agents-tools/index/
    class Agent
      include Resource

      AGENT_TYPES = %w[flow conversational_flow conversational plan_execute_and_reflect].freeze

      # Tool types whose names do not camelize from their key.
      TOOL_TYPES = {
        ml_model: 'MLModelTool',
        vector_db: 'VectorDBTool',
        ppl: 'PPLTool',
        rag: 'RAGTool'
      }.freeze

      self.registry_type = 'agent'
      self.missing_error = Errors::AgentNotRegisteredError

      settings :description, :app_type

      class << self
        include Errors

        def agent_id
          remote_id
        end

        def agent_type(type = nil)
          return settings[:agent_type] if type.nil?
          raise ArgumentError, "Unknown agent type #{type}, expected one of #{AGENT_TYPES.join(', ')}" unless AGENT_TYPES.include?(type.to_s)
          settings[:agent_type] = type.to_s
        end

        # The model the agent reasons with, as a model class reference or a model id.
        def llm(model = nil, parameters: {})
          return settings[:llm] if model.nil?
          settings[:llm] = { model: model, parameters: parameters }
        end

        def memory(type = nil)
          return settings[:memory] if type.nil?
          settings[:memory] = { type: type.to_s }
        end

        # Adds a tool. `model:` and `index:` resolve to a model id and an index name when the
        # agent registers; `name:` and `description:` describe the tool, and the remaining
        # options are sent as tool parameters.
        def tool(type, name: nil, description: nil, **parameters)
          tools << { type: type, name: name, description: description, parameters: parameters }
        end

        def tools
          @tools ||= []
        end

        def register!
          response = client.register_agents(body: to_hash)
          self.remote_id = response['agent_id']
        end

        # Runs the agent with the given parameters and returns its inference results.
        def execute(**parameters)
          raise AgentNotRegisteredError if agent_id.blank?
          client.execute_agent(agent_id: agent_id, body: { parameters: parameters })['inference_results']
        end

        def to_hash
          {
            name: remote_name,
            type: agent_type,
            description: description,
            app_type: app_type,
            llm: llm_body,
            memory: settings[:memory]&.to_hash,
            tools: tools.map { |tool| tool_body(tool) }.presence
          }.compact
        end

        private

        def llm_body
          return unless settings[:llm]
          { model_id: remote_id_for(settings[:llm][:model]), parameters: settings[:llm][:parameters].to_hash.presence }.compact
        end

        def tool_body(tool)
          parameters = tool[:parameters].dup
          parameters[:model_id] = remote_id_for(parameters.delete(:model)) if parameters.key?(:model)
          parameters[:index] = index_name_for(parameters[:index]) if parameters.key?(:index)

          {
            type: TOOL_TYPES.fetch(tool[:type].to_sym) { "#{tool[:type].to_s.camelize}Tool" },
            name: tool[:name],
            description: tool[:description],
            parameters: parameters.presence
          }.compact
        end

        def index_name_for(index)
          index.respond_to?(:index_name) ? index.index_name : index
        end
      end
    end
  end
end
