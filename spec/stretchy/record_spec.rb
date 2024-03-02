require "spec_helper"
require "stretchy/record"
require "models/post"

describe Stretchy::Record do

  describe Post do

    context 'when inherited' do
      it 'includes Elasticsearch::Persistence::Model' do
          expect(described_class).to include(Elasticsearch::Persistence::Model)
      end
      
      it 'includes Stretchy::Associations' do
          expect(described_class).to include(Stretchy::Associations)
      end

      it 'includes Stretchy::Refreshable' do
          expect(described_class).to include(Stretchy::Refreshable)
      end

      it 'infers the index name' do
          expect(described_class.index_name).to eq('posts')
      end

      context 'defaults' do
        context 'attributes' do
          it 'includes an id' do
            expect(described_class.new).to respond_to(:id)
          end

          it 'includes created_at and updated_at' do
            expect(described_class.new).to respond_to(:created_at)
            expect(described_class.new).to respond_to(:updated_at)

          end
        end

        context 'size' do
          it 'defaults to 10000' do
            expect(described_class.default_size).to eq(10000)
          end

          it 'can be overridden' do
            allow(described_class).to receive(:default_size).and_return(100)
            expect(described_class.default_size).to eq(100)
          end


        end
      end

      context 'scoping' do
        before(:example) do

            records = [
              {title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false},
              {title: "goodbye", body: "world", actor: {name: "Jane", age: 40, username: 'janeb'}, tags: ["goodbye", "world"], flagged: true},
              {title: "fun times", body: "Let's have some fun", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["fun", "times"], flagged: false},
              {title: "good title", body: "no more goats please", actor: {name: "Ryosuke", age: 19, username: 'ryo'}, tags: ["goats", "good"], flagged: false},
            ]

            described_class.bulk_in_batches(records, size: 100) do |batch|
              batch.map! { |record| described_class.new(record).to_bulk }
            end
        end

        after(:example) do
            described_class.delete_index! if described_class.index_exists?
        end

        it 'returns a relation' do
            expect(described_class.all.class.superclass).to eq(Elasticsearch::Persistence::Relation)
        end

        it 'counts' do
            expect(described_class.count).to be_a(Numeric)
        end

        context 'named scopes' do
          it 'can receive a named scope' do
            expect(described_class).to respond_to(:scope)
          end

          context 'after defining a scope for flagged records' do
            it 'returns a relation' do
              expect(described_class.flagged.class.superclass).to eq(Elasticsearch::Persistence::Relation)
            end

            it 'returns only flagged records' do
              expect(described_class.flagged.map(&:flagged)).to all(be_truthy)
            end
          end
        end
      end

      context 'indexing' do
        context 'bulk' do
          before(:each) do
            records = [
              {title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false},
              {title: "goodbye", body: "world", actor: {name: "Jane", age: 40, username: 'janeb'}, tags: ["goodbye", "world"], flagged: true},
              {title: "fun times", body: "Let's have some fun", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["fun", "times"], flagged: false},
              {title: "good title", body: "no more goats please", actor: {name: "Ryosuke", age: 19, username: 'ryo'}, tags: ["goats", "good"], flagged: false},
            ]
            described_class.bulk(records.map { |record| described_class.new(record).to_bulk })
            described_class.refresh_index!

          end

          after(:each) do
            described_class.delete_index! if described_class.index_exists?
          end

          xit 'responds to update_all' do
            expect(described_class).to respond_to(:update_all)
          end

          it 'returns operation results' do
            batch_results = described_class.bulk_in_batches(described_class.all, size: 2) do |batch| 
              batch.map! { |record| record.to_bulk } 
            end
            expect(batch_results).to be_a(Array)
            expect(batch_results).to all(be_a(Hash))
            expect(batch_results.first.with_indifferent_access).to include(:took, :errors, :items)
            expect(batch_results.first['items'].size).to eq(2)
          end

          it 'bulk indexes in batches' do 
            expect(described_class).to respond_to(:bulk_in_batches)
            expect(described_class.count).to eq(4)
          end

          it 'bulk updates in batches' do
            described_class.bulk_in_batches(described_class.all, size: 100) do |batch|
              batch.map! { |record| record.flagged = true; record.to_bulk(:update) }
            end
            expect(described_class.flagged.count).to eq(4)
          end

          it 'bulk deletes in batches' do
            described_class.bulk_in_batches(described_class.all, size: 2) do |batch|
              expect(batch.size).to eq(2)
              batch.map! { |record| record.to_bulk(:delete) }
            end
            expect(described_class.count).to eq(0)
          end

          
        end
      end
    end
  end
end