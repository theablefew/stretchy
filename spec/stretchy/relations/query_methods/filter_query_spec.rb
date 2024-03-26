require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::FilterQuery do
  let(:model) {TestModel}
  let!(:relation) { Stretchy::Relation.new(model, {}) }
  let(:value_key) { described_class.name.demodulize.underscore.to_sym }
  let(:relation_values) { relation.values[value_key] }

  context 'api' do
    context 'when not present' do
      it 'should have empty values' do
        expect(relation_values).to be_nil
      end
    end

    it 'has name of filter and args' do
      relation.filter_query(:range, { age: { gte: 18 } })
      expect(relation_values).to eq([args: {age: {:gte => 18}}, name: :range])
    end

  end


  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel}
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
        it 'filters' do
          values[:filter_query] = [args: {age: {:gte => 18}}, name: :range]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            [
              {
                range: {
                  age: {
                    gte: 18
                  }
                }
              }
            ]
          )
        end

        it 'multiple filters' do
          values[:filter_query] = [
            { args: { age: { gte: 18 } }, name: :range },
            { args: { name: 'Lilly' }, name: :term }
          ]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            [
              {
                range: {
                  age: {
                    gte: 18
                  }
                }
              },
              {
                term: {
                  name: 'Lilly'
                }
              }
            ]
          )
        end
      end

    end
  end
end
