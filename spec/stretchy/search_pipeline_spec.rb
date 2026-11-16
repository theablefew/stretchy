require 'spec_helper'

describe Stretchy::SearchPipeline, opensearch_only: true do
  let(:llm) { double('ClaudeModel', remote_id: 'llm-1') }

  let(:pipeline_class) do
    stub_const('ClaudeModel', Class.new(Stretchy::MachineLearning::Model))
    allow(ClaudeModel).to receive(:remote_id).and_return('llm-1')
    klass = Class.new(described_class) do
      description 'Hybrid search with generated answers'
      request_processor :filter_query, query: { term: { visibility: 'public' } }
      phase_results_processor :'normalization-processor', normalization: { technique: 'min_max' }
      response_processor :retrieval_augmented_generation, model: :claude_model, context_field_list: [:body]
    end
    stub_const('RagPipeline', klass)
  end

  it 'groups processors by kind' do
    expect(pipeline_class.to_hash).to eq(
      'description' => 'Hybrid search with generated answers',
      'request_processors' => [{ 'filter_query' => { 'query' => { 'term' => { 'visibility' => 'public' } } } }],
      'response_processors' => [{ 'retrieval_augmented_generation' => { 'context_field_list' => ['body'], 'model_id' => 'llm-1' } }],
      'phase_results_processors' => [{ 'normalization-processor' => { 'normalization' => { 'technique' => 'min_max' } } }]
    )
  end

  it 'leaves out kinds without processors' do
    pipeline = Class.new(described_class) { response_processor :rename_field, field: 'a', target_field: 'b' }
    expect(pipeline.to_hash.keys).to eq(%w[response_processors])
  end

  it 'creates the pipeline under its name' do
    expect(pipeline_class.client).to receive(:put).with(id: 'rag_pipeline', body: pipeline_class.to_hash).and_return('acknowledged' => true)
    expect(pipeline_class.create!).to eq('acknowledged' => true)
  end

  it 'finds and deletes the pipeline' do
    allow(pipeline_class.client).to receive(:get).with(id: 'rag_pipeline').and_return('rag_pipeline' => {})
    expect(pipeline_class.exists?).to be(true)
    expect(pipeline_class.client).to receive(:delete).with(id: 'rag_pipeline').and_return('acknowledged' => true)
    pipeline_class.delete!
  end

  it 'is missing when the cluster does not have it' do
    allow(pipeline_class.client).to receive(:get).and_raise(Stretchy.configuration.backend.not_found_error)
    expect(pipeline_class.exists?).to be(false)
  end

  it 'resolves an agent for the agentic query translator' do
    stub_const('ProductSearchAgent', Class.new(Stretchy::MachineLearning::Agent))
    allow(ProductSearchAgent).to receive(:remote_id).and_return('agent-1')
    pipeline = Class.new(described_class) { request_processor :agentic_query_translator, agent: :product_search_agent }
    expect(pipeline.to_hash['request_processors']).to eq([{ 'agentic_query_translator' => { 'agent_id' => 'agent-1' } }])
  end

  it 'is only available on OpenSearch' do
    expect(pipeline_class.available?).to be(true)
  end

  it 'is not abstract, unlike the base classes' do
    expect([pipeline_class, described_class, Stretchy::IngestPipeline, Stretchy::Pipeline].map(&:abstract?)).to eq([false, true, true, true])
  end
end
