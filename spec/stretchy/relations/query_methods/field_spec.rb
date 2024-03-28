require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Fields do
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

    it 'with multiple fields' do
      relation.fields(:id, :name, :email)
      expect(relation_values).to eq([:id, :name, :email])
    end

    it 'with a single field' do
      relation.fields(:id)
      expect(relation_values).to eq([:id])
    end

  end


  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel}
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:fields) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      
      context 'the structure has' do
        it 'fields' do
          values[:fields] = [:title]
          expect(clause).not_to be_nil
          expect(clause).to eq([:title])
        end
      end

    end
  end
end
