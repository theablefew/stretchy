require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::QueryString do
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
      relation.query_string("((big cat) OR (domestic cat)) AND NOT panther eye_color: green")
      expect(relation_values).to eq(["((big cat) OR (domestic cat)) AND NOT panther eye_color: green"])
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :query_string) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:query_string] = ["((big cat) OR (domestic cat)) AND NOT panther eye_color: green"]
          expect(clause).not_to be_nil
          expect(clause).to eq({ query: "((big cat) OR (domestic cat)) AND NOT panther eye_color: green" })
        end
      end
    end
  end
end