require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Regexp do
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
      relation.regexp(title: /john|jane/)
      expect(relation_values).to eq([[{'title': "john|jane"},{}]])
    end

    it 'detects case insensitive matching' do
      relation.regexp(name: /john|jane/i)
      expect(relation_values).to eq([[{'name': "john|jane"}, {case_insensitive: true}]])
    end

    it 'accepts options' do
      relation.regexp(name: /john|jane/i, flags: 'ALL')
      expect(relation_values).to eq([[{'name': "john|jane"}, {case_insensitive: true, flags: 'ALL'}]])
    end

  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :regexp) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:regexp] = [[{name: 'john|jane'}, {case_insensitive: true, flags: 'ALL'}]]
          expect(clause).not_to be_nil
          expect(clause).to eq({ 'name.keyword': { value: 'john|jane', flags: 'ALL', case_insensitive: true } })
        end
      
        it 'appears when must clause is present' do
          values[:where] = [{title: 'Fun times'}]
          values[:regexp] = [[{name: 'john|jane'}, {case_insensitive: true, flags: 'ALL'}]]
          expect(subject.to_elastic.deep_symbolize_keys.dig(:query, :bool, :must)).to eq(
            {
              term: {
                title: 'Fun times'
              }
            }
          )
          expect(clause).to eq({ 'name.keyword': { value: 'john|jane', flags: 'ALL', case_insensitive: true } }) 
        end
      end
    end
  end
end