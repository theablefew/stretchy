require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Order do
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
      relation.order(age: :desc, name: :asc)
      expect(relation_values).to eq([{age: :desc},{name: :asc}])
    end

    context 'multiple fields' do
      it 'stores values' do
        relation.order(age: :desc, name: :asc, price: {order: :desc, mode: :avg})
        expect(relation_values).to eq([{age: :desc},{name: :asc},{price: {order: :desc, mode: :avg}}])
      end
    end

    context 'with first and last' do
      it 'overrides default sort with last' do
        subject = relation.sort(name: :asc)
        query = relation.last!.to_elastic
        expect(query).to eq({sort: [{'name.keyword': :desc}]}.with_indifferent_access)
      end

      it 'overrides default sort with first' do
          subject = relation.sort(name: :asc)
          query = relation.first!.to_elastic
          expect(query).to eq({sort: [{'name.keyword': :asc}]}.with_indifferent_access)
      end
      
      it 'changes first sort key to desc' do
          subject = relation.sort(name: :asc, age: :desc)
          query = relation.last!.to_elastic
          expect(query[:sort]).to eq([{'name.keyword' => :desc}, {'age' => :desc}])
      end

      it 'changes first sort key to asc' do
          subject = relation.sort(name: :desc, age: :desc)
          query = relation.first!.to_elastic
          expect(query[:sort]).to eq([{'name.keyword' => :asc}, {'age' => :desc}])
      end
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:sort) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:order] = [{age: :desc, name: :asc}]
          expect(clause).not_to be_nil
          expect(clause).to eq([{ age: :desc, 'name.keyword': :asc }])
        end
      
        context 'multiple fields' do
          it 'the correct query' do
            values[:order] = [{age: :desc, name: :asc, price: {order: :desc, mode: :avg}}]
            expect(clause).not_to be_nil
            expect(clause).to eq([{ age: :desc, 'name.keyword': :asc, price: {order: :desc, mode: :avg} }])
          end
        end
      end


    end
  end
end