require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::Where do
  let(:model) {TestModel}
  let!(:relation) { Stretchy::Relation.new(model, {}) }
  let(:value_key) { described_class.name.demodulize.underscore.to_sym }
  let(:relation_values) { relation.values[value_key] }

  context 'api'
    # examples of usage on a StretchyModel

    context 'when not present' do
      it 'should have empty values' do
        expect(relation_values).to be_nil
      end
    end

    context 'when chained' do
      context 'with duplicate conditions' do
        it 'stacks values' do
          relation.where(title: 'Fun times').where(title: 'Sad times')
          expect(relation_values).to eq([{title: 'Fun times'}, {title: 'Sad times'}])
        end
      end
    end


    context 'when using ranges' do
        let(:relation_filter_values) { relation.values[:filter_query] }

        it 'gte and lte with .. ranges' do
          begin_date = 2.days.ago.beginning_of_day.utc
            end_date = 1.day.ago.end_of_day.utc
            relation.where(date: begin_date..end_date)
            expect(relation_filter_values).to eq([args: {date: {:gte => begin_date, :lte => end_date}}, name: :range])
        end

        it 'gte and lt with ... ranges' do
            begin_date = 2.days.ago.beginning_of_day.utc
            end_date = 1.day.ago.end_of_day.utc
            relation.where(date: begin_date...end_date)
            expect(relation_filter_values).to eq([args: {date: {:gte => begin_date, :lt => end_date}}, name: :range])
        end
    
        it 'handles integer ranges' do
          relation.where(age: 18..30)
          expect(relation_filter_values).to eq([args: {age: {:gte => 18, :lte => 30}}, name: :range])
        end
    
        it 'handles explicit range values' do
          relation.where(price: {gte: 100})
          expect(relation_filter_values).to eq([args: {price: {:gte => 100}}, name: :range])
        end
      end
    
      context 'when using regex' do
        let(:relation_regexp_values) { relation.values[:regexp] }

        it 'handles regex' do
          relation.where(color: /gr(a|e)y/)
          expect(relation_regexp_values).to eq([[{"color.keyword"=>"gr(a|e)y"}, {}]])
          expect(relation_values).to be_nil
        end

        it 'handles regex with flags' do
          relation.where(color: /gr(a|e)y/i)
          expect(relation_regexp_values).to eq([[{"color.keyword"=>"gr(a|e)y"}, {:case_insensitive=>true}]])
          expect(relation_values).to be_nil
        end

        it 'handles multiple conditions' do
          relation.where(color: /gr(a|e)y/, age: 30)
          expect(relation_regexp_values).to eq([[{"color.keyword"=>"gr(a|e)y"}, {}]])
          expect(relation_values).to eq([{age: 30}])
        end
      end
    
      context 'when using terms' do
        it 'handles terms' do
          relation.where(name: ['Candy', 'Lilly'])
          expect(relation_values).to eq([{name: ['Candy', 'Lilly']}])
        end
      end
    
      context 'when using ids' do
        it 'handles ids' do
          relation.where(id: [12, 80, 32])
          expect(relation.values[:ids]).to eq([[12, 80, 32]])
          expect(relation_values).to be_nil  
        end
      end

  end

  describe Stretchy::Relations::QueryBuilder do
    let(:model) { TestModel}
    let(:attribute_types) { model.attribute_types }

    let(:values) { {} } 
    let(:clause) { subject.to_elastic.deep_symbolize_keys.dig(:query, :bool, :must) }

    subject { described_class.new(values, attribute_types) }

    context 'when built' do
      
      context 'the structure has' do
        it 'query.bool.must' do
          values[:where] = [{title: 'Fun times'}]
          expect(clause).not_to be_nil
        end
      end

      context 'with a text attribute' do
        context 'when configuration.auto_target_keywords' do
          it 'adds .keyword' do
            values[:where] = [{name: 'Zeenor'}]
            expect(clause).to eq(
              {
                term: {
                  'name.keyword': 'Zeenor'
                }
              }
            )
          end
        end

        context 'when configuration.auto_target_keywords is false' do
          it 'does not add .keyword' do
            Stretchy.configuration.auto_target_keywords = false
            values[:where] = [{name: 'Zeenor'}]
            expect(clause).to eq(
              {
                term: {
                  name: 'Zeenor'
                }
              }
            )
          end
        end
      end

      context 'with single term' do
        it 'is a term query' do
          values[:where] = [{title: 'Fun times'}]
          expect(clause).to eq(
              {
                term: {
                  title: 'Fun times'
                }
              }
          )
        end
      
        it 'creates a term query for each distinct field' do
          values[:where] = [{title: 'Fun times'}, {color: 'blue'}]
          expect(clause).to eq(
            [
              {
                term: {
                  title: 'Fun times'
                }
              },
              {
                term: {
                  color: 'blue'
                }
              }
            ]
          )
        end
      end

      context 'when array of terms' do
        it 'is a terms query' do
          values[:where] = [{color: ['blue', 'green']}]
          expect(clause).to eq(
            {
              terms: {
                color: ['blue', 'green']
              }
            }
          )
        end
      end

      context 'when key appears multiple times' do
        it 'is a terms query' do
          values[:where] = [
            {title: 'Fun times'}, 
            {title: 'Sad times'},
            {color: 'blue'}
          ]
          expect(clause).to eq(
            [
              {
                terms: {
                  title: ["Fun times", "Sad times"]
                }
              },
              {
                term: {
                  color: 'blue'
                }
              }
            ]
          )
        end
      end

    end
  end
