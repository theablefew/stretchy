require 'spec_helper'

describe Stretchy::Attributes::Type::Semantic do
  let(:model_class) do
    klass = Class.new(StretchyModel)
    stub_const('SemanticModel', klass)
    klass
  end

  it 'has a type' do
    model_class.attribute :body, :semantic, model_id: 'abc'
    expect(model_class.attribute_types['body'].type).to eq(:semantic)
  end

  it 'maps the model id' do
    model_class.attribute :body, :semantic, model_id: 'abc'
    expect(model_class.attribute_types['body'].mappings(:body)).to eq({ body: { type: :semantic, model_id: 'abc' } }.as_json)
  end

  it 'maps the remaining options' do
    model_class.attribute :body, :semantic, model_id: 'abc', search_model_id: 'def', raw_field_type: 'match_only_text', chunking: true, skip_existing_embedding: true
    expect(model_class.attribute_types['body'].mappings(:body)).to eq(
      { body: { type: :semantic, model_id: 'abc', search_model_id: 'def', raw_field_type: 'match_only_text', chunking: true, skip_existing_embedding: true } }.as_json
    )
  end

  it 'resolves model classes to their ids' do
    embedding_model = Class.new { def self.remote_id = 'model-123' }
    stub_const('EmbeddingModel', embedding_model)
    model_class.attribute :body, :semantic, model_id: :embedding_model, search_model_id: EmbeddingModel
    expect(model_class.attribute_types['body'].mappings(:body)).to eq({ body: { type: :semantic, model_id: 'model-123', search_model_id: 'model-123' } }.as_json)
  end

  it 'is included in the model mappings' do
    model_class.attribute :body, :semantic, model_id: 'abc'
    expect(model_class.attribute_mappings.as_json.dig('properties', 'body')).to eq({ 'type' => 'semantic', 'model_id' => 'abc' })
  end
end
