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
      attribute :title, :keyword
    end
    MyModel
  end


  it 'converts keyword attribute names to .keyword' do
    transformed_keywords = values[:where].map do |arg|
      described_class.new(model.attribute_types).transform(arg)
    end
    expect(transformed_keywords).to eq([{ 'title.keyword' => 'Lilly' }])
  end

  it 'does not transform protected parameters keys to .keyword' do
    model.attribute :terms, :keyword
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