require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::NeuralSparse, opensearch_only: true do
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
      relation.neural_sparse(passage_embedding: 'hello world', model_id: '1234', max_token_score: 2)
      expect(relation_values).to eq([{passage_embedding: 'hello world', model_id: '1234', max_token_score: 2}])
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :neural_sparse) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:neural_sparse] = [{passage_embedding: 'hello world', model_id: '1234', max_token_score: 2}]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            passage_embedding: {
              model_id: '1234',
              max_token_score: 2,
              query_text: 'hello world'
            }
          )
        end

        context 'multiple chained .neural_sparse' do
          #TODO: Need to test if multiple neural_sparse queries are allowed in OpenSearch
          it 'overwrites the last value' do
            values[:neural_sparse] = [{passage_embedding: 'hello world', model_id: '1234', max_token_score: 2}, {passage_embedding: 'goodbye world', model_id: '4321', max_token_score: 3}]
            expect(clause).not_to be_nil
            expect(clause).to eq(
                {
                  passage_embedding: {
                    model_id: '4321',
                    max_token_score: 3,
                    query_text: 'goodbye world'
                  }
                }
            )
          end
        end
      end
    end
  end
end