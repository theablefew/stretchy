require 'spec_helper'

describe Stretchy::Relations::QueryBuilder do
  let(:values) { { aggregation: {categories: { field: 'category', size: 10 }}, filter: { term: { status: 'active' } } } }
  subject { described_class.new(values) }

  describe '#aggregations' do
    it 'returns the aggregations value' do
      expect(subject.aggregations).to eq(values[:aggregation])
    end
  end

  describe '#filters' do
    it 'returns the filters value' do
      expect(subject.filters).to eq(values[:filter])
    end
  end

  describe '#or_filters' do
    it 'returns the or_filters value' do
      expect(subject.or_filters).to eq(values[:or_filter])
    end
  end

  describe '#where' do
    it 'returns the compacted where value' do
      multi_terms = {where: [{status: 'active'}, {category: 'ruby'}]}
      expect(described_class.new(multi_terms).query).to eq(subject.send(:compact_where, multi_terms[:where]))
    end
  end

  describe '#build_query' do
        context 'when missing bool query, query string, and query filter' do
            it 'returns nil' do
                allow(subject).to receive(:missing_bool_query?).and_return(true)
                allow(subject).to receive(:missing_query_string?).and_return(true)
                allow(subject).to receive(:missing_query_filter?).and_return(true)

                expect(subject.send(:build_query)).to be_nil
            end
        end

        context 'when not missing bool query' do
            let(:subject) { described_class.new(bool_query) }

            context 'when using where' do
                let(:bool_query) { {where: [{status: :active}]}} 

                it 'builds the query structure' do
                    expect(subject.send(:build_query)[:bool][:must]).to eq({term: {status: :active}}.with_indifferent_access)
                end
            end

            context 'when using must_not' do
                let(:bool_query) { {must_not: [{status: :inactive}]}}

                it 'builds the query structure' do
                    expect(subject.send(:build_query)[:bool][:must_not]).to eq({term: {status: :inactive}}.with_indifferent_access)
                end
            end

            context 'when using should' do
                let(:bool_query) { {should: [{status: :active}]}}
                it 'builds the query structure' do
                    expect(subject.send(:build_query)[:bool][:should]).to eq({term: {status: :active}}.with_indifferent_access)
                end
            end
        end

        context 'when using filters' do
            let(:subject) { described_class.new(filters) }
            let(:filters) { {filter: [name: :active, args: {term: {status: :active}}]} }
    
            it 'builds the query structure' do
                expect(subject.send(:build_query)[:bool][:filter]).to include({active: {term: {status: :active}}}.with_indifferent_access)
            end
    
        end

        context 'sorting' do
          it 'accepts array of hashes' do
            sorts = [{created_at: :desc}, {title: :asc}]
            subject = described_class.new(order: sorts)
            query = subject.to_elastic
            expect(query).to eq({sort: sorts}.with_indifferent_access)
          end
        
          it 'accepts options' do 
            sorts = [{price: { order: :desc, mode: :avg}}]
            subject = described_class.new(order: sorts)
            query = subject.to_elastic
            expect(query).to eq({sort: sorts}.with_indifferent_access)
          end
        end
  end



end