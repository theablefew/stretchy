require "spec_helper"
require "stretchy/record"
require "models/post"

describe Stretchy::Record do

  describe Post do

    context 'when inherited' do

      it 'includes Stretchy::Associations' do
          expect(described_class).to include(Stretchy::Associations)
      end

      it 'includes Stretchy::Refreshable' do
          expect(described_class).to include(Stretchy::Refreshable)
      end

      it 'infers the index name' do
          expect(described_class.index_name).to eq(described_class.model_name.collection)
      end

      it 'inspects records' do
          d = described_class.new
          inspect_matches = d.attributes.map {|k,v| d.inspect =~ Regexp.new("#{k}\:\s")}
          expect(inspect_matches).to all(be_truthy)
      end

      xit 'timestamps records' do
        
      end

      context 'circuit_breaker_callbacks' do
        it 'esnures query has an option' do
          described_class.query_must_have :routing, in: :search_option, validate_with: Proc.new { |options, values| options.include? :routing }
          expect(described_class).to respond_to(:_circuit_breaker_callbacks)
          expect { described_class.first }.to raise_error(Stretchy::Errors::QueryOptionMissing)
          described_class._circuit_breaker_callbacks.clear
        end
      end

      context 'defaults' do
        context 'attributes' do
          it 'includes an id' do
            expect(described_class.new).to respond_to(:id)
          end

          it 'is assigned an id on create' do
            expect(described_class.create.id).to be_a(String)
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

      context 'crud' do

        it 'creates' do
          document = described_class.create({title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false})
          described_class.refresh_index!
          expect(document.id).not_to be_nil 
        end

        it 'saves' do
          document = described_class.new({title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false})
          document.save
          expect(document.id).not_to be_nil 
        end

        it 'deletes' do
          document = described_class.create({title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false})
          expect(document.delete).to be_truthy
        end

        it 'updates' do
          document = described_class.create({title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false})
          document.update({title: "goodbye"})
          expect(document.title).to eq("goodbye")
          described_class.refresh_index!
          expect(described_class.last.title).to eq("goodbye")
        end

        it 'refreshes index after save' do
          document = described_class.new({title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false})
          expect(document).to receive(:refresh_index)
          document.save
        end

        it 'refreshes index after destroy' do
          document = described_class.create({title: "hello", body: "world", actor: {name: "John", age: 30, username: 'johnny'}, tags: ["hello", "world"], flagged: false})
          expect(document).to receive(:refresh_index)
          document.destroy
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
            expect(described_class.all.class.superclass).to eq(Stretchy::Relation)
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
              expect(described_class.flagged.class.superclass).to eq(Stretchy::Relation)
            end

            it 'returns only flagged records' do
              expect(described_class.flagged.map(&:flagged)).to all(be_truthy)
            end
          end
        end
      end

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

          it 'indexes in batches' do 
            expect(described_class).to respond_to(:bulk_in_batches)
            expect(described_class.count).to eq(4)
          end

          it 'updates in batches' do
            described_class.bulk_in_batches(described_class.all, size: 100) do |batch|
              batch.map! { |record| record.flagged = true; record.to_bulk(:update) }
            end
            expect(described_class.flagged.count).to eq(4)
          end

          it 'deletes in batches' do
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