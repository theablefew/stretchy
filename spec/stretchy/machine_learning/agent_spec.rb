require 'spec_helper'

describe Stretchy::MachineLearning::Agent, opensearch_only: true do
  let(:registry) { double('Registry', remote_id: nil, update: true, delete: true) }
  let(:embedding_model) { double('EmbeddingModel', remote_id: 'embed-1') }
  let(:index) { double('Post', index_name: 'posts') }

  let(:agent) do
    stub_const('EmbeddingModel', Class.new(Stretchy::MachineLearning::Model))
    allow(EmbeddingModel).to receive(:remote_id).and_return('embed-1')
    posts = index
    klass = Class.new(described_class) do
      agent_type :conversational_flow
      description "Answers support questions"
      llm 'llm-1', parameters: { max_iteration: 5 }
      memory :conversation_index
      tool :vector_db, model: :embedding_model, index: posts, embedding_field: 'body_embedding'
      tool :ml_model, name: 'answer', model: 'llm-1', prompt: '${parameters.question}'
    end
    stub_const('SupportAgent', klass)
  end

  before { allow(agent).to receive(:registry).and_return(registry) }

  context 'to_hash' do
    let(:body) { agent.to_hash.as_json }

    it 'describes the agent' do
      expect(body).to include('name' => 'support_agent', 'type' => 'conversational_flow', 'description' => 'Answers support questions')
    end

    it 'sends the llm and memory' do
      expect(body['llm']).to eq('model_id' => 'llm-1', 'parameters' => { 'max_iteration' => 5 })
      expect(body['memory']).to eq('type' => 'conversation_index')
    end

    it 'resolves tool models and indexes' do
      expect(body['tools']).to eq([
        { 'type' => 'VectorDBTool', 'parameters' => { 'index' => 'posts', 'embedding_field' => 'body_embedding', 'model_id' => 'embed-1' } },
        { 'type' => 'MLModelTool', 'name' => 'answer', 'parameters' => { 'prompt' => '${parameters.question}', 'model_id' => 'llm-1' } }
      ])
    end

    it 'camelizes tool types without an acronym' do
      agent.tool :search_index
      expect(agent.to_hash[:tools].last[:type]).to eq('SearchIndexTool')
    end
  end

  it 'rejects an unknown agent type' do
    expect { agent.agent_type :chatty }.to raise_error(ArgumentError, /Unknown agent type chatty/)
  end

  context 'register!' do
    it 'stores the agent id in the registry' do
      expect(agent.client).to receive(:register_agents).with(body: agent.to_hash).and_return('agent_id' => 'agent-1')
      expect(registry).to receive(:update).with(remote_id: 'agent-1')
      agent.register!
      expect(agent.agent_id).to eq('agent-1')
    end
  end

  context 'execute' do
    it 'returns the inference results' do
      allow(agent).to receive(:remote_id).and_return('agent-1')
      results = [{ 'output' => [{ 'name' => 'answer', 'result' => 'Use the reset link.' }] }]
      expect(agent.client).to receive(:execute_agent)
        .with(agent_id: 'agent-1', body: { parameters: { question: 'How do I reset my password?' } })
        .and_return('inference_results' => results)
      expect(agent.execute(question: 'How do I reset my password?')).to eq(results)
    end

    it 'raises AgentNotRegisteredError when unregistered' do
      expect { agent.execute(question: 'hi') }.to raise_error(Stretchy::MachineLearning::Errors::AgentNotRegisteredError)
    end
  end

  context 'find and delete!' do
    before { allow(agent).to receive(:remote_id).and_return('agent-1') }

    it 'gets the agent by id' do
      expect(agent.client).to receive(:get_agent).with(agent_id: 'agent-1').and_return('name' => 'support_agent')
      expect(agent.exists?).to be(true)
    end

    it 'is missing when the cluster does not have it' do
      allow(agent.client).to receive(:get_agent).and_raise(Stretchy.configuration.backend.not_found_error)
      expect(agent.exists?).to be(false)
    end

    it 'deletes the remote agent before forgetting it' do
      expect(agent.client).to receive(:delete_agent).with(agent_id: 'agent-1').ordered.and_return('result' => 'deleted')
      expect(registry).to receive(:delete).ordered
      agent.delete!
    end
  end
end
