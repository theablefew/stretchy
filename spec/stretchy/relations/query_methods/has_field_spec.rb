require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::HasField do
  let(:model) { TestModel }
  let!(:relation) { Stretchy::Relation.new(model, {}) }
  let(:value_key) { described_class.name.demodulize.underscore.to_sym }
  let(:relation_values) { relation.values[:filter_query] }

  context 'api' do
    context 'when not present' do
      it 'should have empty values' do
        expect(relation_values).to be_nil
      end
    end

    it 'builds a filter query' do
      relation.has_field(:title)
      expect(relation_values).to eq([args: {field: :title}, name: :exists])
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :bool, :filter) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:filter_query] = [args: {field: :title}, name: :exists]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            [
              {
                exists: {
                  field: :title
                }
              }
            ]
          )
        end
      end
    end
  end
end