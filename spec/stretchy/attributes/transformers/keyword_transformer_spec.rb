require 'spec_helper'

describe Stretchy::Attributes::Transformers::KeywordTransformer do

  let(:values) { 
    { 
      where: [{ title: 'Lilly' }], 
      filter_query: [{ name: :terms, args: { term: 'value' } }],
      aggregation: [{:args=>{:terms=>{:field=>"terms"}}, :name=>:terms}],
      size: 1000
    }
  }

  let (:model) do
    class MyModel < Stretchy::Record
      attribute :title, :text
      attribute :text_with_keyword, :text, fields: {slug: {type: :keyword}}
      attribute :no_keyword, :text, fields: {no_keyword: {type: :text}}
      attribute :hash_with_keyword, :hash
    end
    MyModel
  end


  it 'converts keyword attribute names to .keyword' do
    transformed_keywords = values[:where].map do |arg|
      described_class.new(model.attribute_types).transform(arg)
    end
    expect(transformed_keywords).to eq([{ 'title.keyword' => 'Lilly' }])
  end

  context 'when hash' do
    let(:values) { {where: [{'hash_with_keyword.title': 'Lilly' }]} }
    it 'converts dot notation to .keyword' do
      transformed_keywords = values[:where].map do |arg|
        described_class.new(model.attribute_types).transform(arg).with_indifferent_access
      end
      expect(transformed_keywords).to eq([{ 'hash_with_keyword.title.keyword' => 'Lilly' }])
    end
  end

  context 'when multifield' do
    let(:values) { {where: [{text_with_keyword: 'Cici' }]} }

    it 'automatically uses a keyword field if available' do
      transformed_keywords = values[:where].map do |arg|
        described_class.new(model.attribute_types).transform(arg).with_indifferent_access
      end
      expect(transformed_keywords).to eq([{ 'text_with_keyword.slug' => 'Cici' }])
    end

    it 'does not transform if the attribute does not have a keyword field' do
      values[:where] = [{ no_keyword: 'Mia' }]
      transformed_keywords = values[:where].map do |arg|
        described_class.new(model.attribute_types).transform(arg).with_indifferent_access
      end
      expect(transformed_keywords).to eq([{ 'no_keyword' => 'Mia' }])

    end
  end

  context 'when auto_target_keywords is false' do
    before(:each) do
      Stretchy.configure do |config|
        config.auto_target_keywords = false
      end
    end

    after(:each) do
      Stretchy.configure do |config|
        config.auto_target_keywords = true
      end
    end

    it 'does not transform' do
      transformed_keywords = values[:where].map do |arg|
        described_class.new(model.attribute_types).transform(arg)
      end 
    end
  end


  it 'does not transform protected parameter keys to .keyword' do
    model.attribute :terms, :text
    transformed_keywords = values[:aggregation].map do |arg|
      described_class.new(model.attribute_types).transform(arg, :name)
    end
    expect(transformed_keywords).to eq([{ name: :terms, args: { terms: { field: 'terms.keyword' } } }])
  end

  it 'does not convert aggregation or filter name values to .keyword' do
    transformed_keywords = values[:filter_query].map do |arg|
      described_class.new(model.attribute_types).transform(arg, :name)
    end
    expect(transformed_keywords).to eq([{ name: :terms, args: { term: 'value' } }])
  end

  it 'handles nested hashes' do
    values = [{ name: :terms, args: { terms: {field: 'value'}, aggs: { more_terms: { terms: { field: :title }}}}}]
    transformed_keywords = values.map do |arg|
      described_class.new(model.attribute_types).transform(arg, :name)
    end
    expect(transformed_keywords).to eq([{ name: :terms, args: { terms: { field: 'value' }, aggs: { more_terms: { terms: { field: 'title.keyword' }}}}}])
  end

end