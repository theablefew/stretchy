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
    before do
      class TestModel < Stretchy::Record
        attribute :name, :text
        attribute :age, :integer
        attribute :tags, :array
        attribute :data, :hash
      end
    end

    it 'array type is registered' do
      expect(TestModel.attribute_types['tags'].type).to eq(:array)
    end

    it 'hash type is registered' do
      expect(TestModel.attribute_types['data'].type).to eq(:hash)
    end

    it 'keyword type is registered' do
      expect(TestModel.attribute_types['name'].type).to eq(:text)
    end

    it 'text type is registered' do
      expect(TestModel.attribute_types['age'].type).to eq(:integer)
    end

    context 'hash' do
      it 'cast_value' do
        expect(TestModel.attribute_types['data'].cast({})).to be_a Elasticsearch::Model::HashWrapper
      end
    end
  end

end