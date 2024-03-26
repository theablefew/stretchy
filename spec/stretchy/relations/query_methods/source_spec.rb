require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Source do
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

    it 'stores values for includes' do
      relation.source(includes: [:name, :email])
      expect(relation_values).to eq([{ includes: [:name, :email] }])
    end

    it 'stores values for excludes' do
      relation.source(excludes: [:name, :email])
      expect(relation_values).to eq([{ excludes: [:name, :email] }])
    end

    it 'stores values for boolean' do
      relation.source(false)
      expect(relation_values).to eq([false])
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:_source) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query for includes' do
          values[:source] = [{ includes: [:name, :email] }]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            {
              includes: [:name, :email]
            }
          )
        end

        it 'the correct query for excludes' do
          values[:source] = [{ excludes: [:name, :email] }]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            {
              excludes: [:name, :email]
            }
          )
        end

        it 'the correct query for boolean' do
          values[:source] = [false]
          expect(clause).not_to be_nil
          expect(clause).to eq(false)
        end
      end
    end
  end
end