require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Match do

  context 'api' do
    let(:model) {TestModel}
    let(:relation) { Stretchy::Relation.new(model, {}) }
    let(:value_key) { described_class.name.demodulize.underscore.to_sym }
    let(:relation_values) { relation.values[value_key] }
    
    it 'registers' do
      expect(Stretchy::Relations::QueryMethods.registry).to include(:match)
    end

    context 'serializes values' do
      it 'without options' do
        relation.match(path: 'attributes/types')
        expect(relation_values).to eq([{path: 'attributes/types'}])
      end

      it 'with options' do
        relation.match(path: 'attributes/types', fuzziness: 3, operator: "AND")
        expect(relation_values).to eq([{path: 'attributes/types'}, {fuzziness: 3, operator: "AND"}])
      end
    end

  end

  describe Stretchy::Relations::QueryBuilder do
    let(:attribute_types) { double('model', attribute_types: { "path": Stretchy::Attributes::Type::Text.new })}
    let(:values) { {} } 
		let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :match) }

    before do
      allow(attribute_types).to receive(:[])
    end

    context 'when built' do
      subject { described_class.new(values, attribute_types) }

      context 'without a match query' do
        it 'match is not present' do
          values[:where] = [{first_name: 'Irving' }]
          expect(clause).to be_falsey
        end
      end

      context 'with a match query' do
        it 'match is present' do
          values[:match] = [{ path: 'attributes/types'}, {fuzziness: 3, operator: "AND"}]
          expect(clause).to eq({ path: { query: 'attributes/types', fuzziness: 3, operator: "AND" } })
        end

      end
    end

  end
  
end