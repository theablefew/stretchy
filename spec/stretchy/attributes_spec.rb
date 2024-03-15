require 'spec_helper'

describe Stretchy::Attributes do
  
  it 'array type is registered' do
    expect(ActiveModel::Type.lookup(:array).type).to eq(:array)
  end

  it 'hash type is registered' do
    expect(ActiveModel::Type.lookup(:hash).type).to eq(:hash)
  end

  it 'keyword type is registered' do
    expect(ActiveModel::Type.lookup(:keyword).type).to eq(:keyword)
  end

  it 'text type is registered' do
    expect(ActiveModel::Type.lookup(:text).type).to eq(:text)
  end

  context 'in model' do
    let(:model) do
      class AttributeModel < Stretchy::Record
        attribute :name, :text
        attribute :age, :integer 
        attribute :tags, :array
        attribute :data, :hash, properties: {weights: {type: :array}, biases: {type: :integer}}
        attribute :flagged, :boolean, default: false
        attribute :body, :text
        attribute :only_text, :text, fields: false
      end
      AttributeModel
    end

    context 'hash' do
      it 'cast_value' do
        expect(model.attribute_types['data'].cast({})).to be_a Elasticsearch::Model::HashWrapper
      end
    end


    context 'mappings' do

      it 'returns mappings' do
        expect(model.attribute_mappings).to eq({
          properties: {
            name: {type: :text},
            age: {type: :integer},
            tags: {type: :array},
            data: {type: :hash, properties: {weights: {type: :array}, biases: {type: :integer}}},
            flagged: {type: :boolean},
            id: { type: :keyword },
            created_at: { type: :datetime },
            updated_at: { type: :datetime }
          }
        }.as_json) 
      end

      context 'auto keyword fields for text fields' do
        it 'adds keyword to text fields' do
          expect(model.attribute_mappings['properties']['body']).to eq({type: :text, fields: {keyword: {type: :keyword, ignore_above: 256}}}.as_json)
        end

        it 'does not add keyword to text fields when fields is false' do
          expect(model.attribute_mappings['properties']['only_text']).to eq({type: :text, fields: false}.as_json)
        end

        it 'does not add keyword to text fields when fields is present' do
          model.attribute :location, :text, fields: {raw: {type: :keyword}}
          expect(model.attribute_mappings['properties']['location']).to eq({type: :text, fields: {raw: {type: :keyword}}}.as_json)
        end
      end


    end
  end

end