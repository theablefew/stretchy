require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Size do
  let(:model) { TestModel }
  let!(:relation) { Stretchy::Relation.new(model, {}) }
  let(:value_key) { described_class.name.demodulize.underscore.to_sym }
  let(:relation_values) { relation.values[value_key] }

  context 'api' do
    context 'when not present' do
      it 'should have empty values' do
        expect(relation_values).to be_nil
      end
    end

    it 'stores values' do
      relation.size(10)
      expect(relation_values).to eq(10)
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {default_size: default_size } } 
    let(:default_size) { 10000 }
    let(:clause) { subject.search_options.dig(:size) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'has default size' do
          expect(clause).to eq(default_size)
        end
      end

      context 'when count' do
        it 'has no size' do
          values[:count] = true
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:size] = 10
          expect(clause).not_to be_nil
          expect(clause).to eq(values[:size])
        end
      end
    end
  end
end