require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Hybrid, opensearch_only: true do
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
      relation.hybrid(
        neural: {
            passage_embedding: 'hello world', 
            model_id: '1234', 
            k: 2
        }, 
        query: {
          term: {
            status: :active
          }
        }
      )
      expect(relation_values).to eq(
        
          {
            neural: {
              passage_embedding: 'hello world', 
              model_id: '1234', 
              k: 2
            },
            query: {
              term: {
                status: :active
              }
            }
          }
        
      )
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :hybrid) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:hybrid] = 
            {
              neural: {
                passage_embedding: 'hello world', 
                model_id: '1234', 
                k: 2
              },
              query: {
                term: {
                  status: :active
                }
              }
            }
          
          expect(clause).not_to be_nil
          expect(clause).to eq(
            {
              queries: [
                {
                  neural: {
                    passage_embedding: {
                      query_text: 'hello world',
                      model_id: '1234',
                      k: 2
                    }
                  }
                },
                {
                  term: {
                    status: :active
                  }
                }
              ]
            }
          )
        end
      end
    end
  end
end