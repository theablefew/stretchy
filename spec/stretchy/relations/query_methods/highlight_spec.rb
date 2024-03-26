require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Highlight do
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
      relation.highlight(:title)
      expect(relation_values).to eq([:title])
    end

    context 'with options' do
      it 'stores values' do
        relation.highlight(name: {pre_tags: "__", post_tags: "__"})
        expect(relation_values).to eq([{name: {pre_tags: "__", post_tags: "__"}}])
      end
    end
  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel }
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:highlight) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      context 'with no values' do
        it 'is nil' do
          expect(clause).to be_nil
        end
      end
      
      context 'the structure has' do
        it 'the correct query' do
          values[:highlight] = [:title]
          expect(clause).not_to be_nil
          expect(clause).to eq(
            {
              fields: {
                title: {}
              }
            }
          )
        end

        context 'with options' do
          it 'the correct query' do
            values[:highlight] = [{name: {pre_tags: "__", post_tags: "__"}}]
            expect(clause).not_to be_nil
            expect(clause).to eq(
              {
                fields: {
                  name: {
                    pre_tags: "__",
                    post_tags: "__"
                  }
                }
              }
            )
          end
        end
      end
    end
  end
end