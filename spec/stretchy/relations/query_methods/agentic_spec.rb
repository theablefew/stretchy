require 'spec_helper'

describe Stretchy::Relations::QueryMethods::Agentic do
  let(:model) do
    stub_const('Product', Class.new(StretchyModel) do
      attribute :name, :text
    end)
  end

  it 'builds the agentic query clause' do
    expect(model.agentic('red shoes').to_elastic).to eq('query' => { 'agentic' => { 'query_text' => 'red shoes' } })
  end

  it 'includes query fields and a memory id' do
    query = model.agentic('red shoes', query_fields: [:name], memory_id: 'm1').to_elastic
    expect(query['query']['agentic']).to eq('query_text' => 'red shoes', 'query_fields' => ['name'], 'memory_id' => 'm1')
  end

  it 'replaces an earlier agentic query' do
    expect(model.agentic('red shoes').agentic('blue hats').to_elastic['query']['agentic']['query_text']).to eq('blue hats')
  end

  it 'chains with a search pipeline' do
    relation = model.search_pipeline('agentic_pipeline').agentic('red shoes')
    expect(relation.search_option_values).to include(search_pipeline: 'agentic_pipeline')
    expect(relation.to_elastic['query']).to have_key('agentic')
  end
end
