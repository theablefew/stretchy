require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Neural, opensearch_only: true do
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

    context 'unimodal' do
      it 'stores values' do
        relation.neural(body_embeddings: 'hello world', model_id: '1234')
        expect(relation_values).to eq([{body_embeddings: 'hello world', model_id: '1234'}])
      end
    end

    context 'multimodal' do
      it 'stores values' do
        relation.neural(body_embeddings: {query_text: 'hello world', query_image: 'base64encodedimage'}, model_id: '1234')
        expect(relation_values).to eq([{body_embeddings: {query_text: 'hello world', query_image: 'base64encodedimage'}, model_id: '1234'}])
      end
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :neural) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        context 'multimodal' do
          it 'the correct query' do
            values[:neural] = [{body_embeddings: {query_text: 'hello world', query_image: 'base64encodedimage'}, model_id: '1234'}]
            expect(clause).not_to be_nil
            expect(clause).to eq(
              body_embeddings: {
                model_id: '1234',
                query_text: 'hello world',
                query_image: 'base64encodedimage'
              }
            )
          end
        end

        context 'unimodal' do
          it 'the correct query' do
            values[:neural] = [{body_embeddings: 'hello world', model_id: '1234'}]
            expect(clause).not_to be_nil
            expect(clause).to eq(
              body_embeddings: {
                model_id: '1234',
                query_text: 'hello world'
              }
            )
          end
        end
      end
    end
  end
end