require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Ids do
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
      relation.ids([1, 2, 3])
      expect(relation_values).to eq([[1, 2, 3]])
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :ids) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:ids] = [1, 2, 3]
          expect(clause).not_to be_nil
          expect(clause).to eq({ values: [1, 2, 3] })
        end
      
        context 'multiple chained .ids' do
          it 'the correct query' do
            values[:ids] = [[1, 2, 3], [2,6,9]]
            expect(clause).not_to be_nil
            expect(clause).to eq({ values: [1, 2, 3, 6, 9] })
          end
        end
      end
    end
  end
end