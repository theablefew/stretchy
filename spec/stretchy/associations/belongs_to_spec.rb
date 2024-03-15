require 'spec_helper'

describe Stretchy::Associations do

  context 'belongs_to' do
    let(:publisher_model) {
      class Publisher < Stretchy::Record

        attribute :title, :keyword
        attribute :description, :string

        validates_presence_of :title
      end
      Publisher
    }

    let(:book_model) {
      class Book < Stretchy::Record
          
          attribute :title, :keyword
          attribute :description, :string
          attribute :published_at, :date
          attribute :publisher_id, :keyword
    
          belongs_to :publisher

          validates_presence_of :title
      end
      Book
    }

    let(:publisher) { publisher_model.create title: 'Penguin', description: 'A book publisher' }

    before(:each) do
      publisher_model
    end

    it 'responds_to belongs_to' do
      expect(book_model).to respond_to(:belongs_to)
    end

    it 'reflects the association' do
      book = book_model.create title: 'The Hobbit', description: 'A book about a hobbit', published_at: Time.now, publisher_id: publisher.id
      expect(book.association_reflection(:publisher)).to be_a Stretchy::Relation
    end

    context 'configuration' do
    
      context 'defaults' do

        let(:options) { book_model.class_variable_get(:@@_association_options) }
        it 'sets the foreign key' do
          expect(options[:publisher][:foreign_key]).to eq('publisher_id')
        end
        it 'sets the primary key' do
          expect(options[:publisher][:primary_key]).to eq('id')
        end
        it 'sets the class name' do
          expect(options[:publisher][:class_name]).to eq(:publisher)
        end
      end

      context 'custom' do
        let(:custom_model) {
          class Custom < Stretchy::Record
            attribute :title, :keyword
            attribute :description, :string
            attribute :custom_id, :keyword
            belongs_to :distributor, foreign_key: 'custom_id', class_name: :publisher, primary_key: 'uuid'
          end
          Custom
        }
        let(:options) { custom_model.class_variable_get(:@@_association_options) }
        it 'sets the foreign key' do
          expect(options[:distributor][:foreign_key]).to eq('custom_id')
        end
        it 'sets the primary key' do
          expect(options[:distributor][:primary_key]).to eq('uuid')
        end
        it 'sets the class name' do
          expect(options[:distributor][:class_name]).to eq(:publisher)
        end
      end

    end
  

    context 'it assigns the association' do
      it 'with id' do
        book = book_model.create title: 'The Hobbit', description: 'A book about a hobbit', published_at: Time.now, publisher_id: publisher.id
        expect(book.publisher_id).to eq(publisher.id)
        expect(book.publisher.id).to eq(publisher.id)
      end

      it 'with object' do
        book = book_model.create title: 'The Hobbit', description: 'A book about a hobbit', published_at: Time.now, publisher: publisher
        expect(book.publisher).to eq(publisher)
      end

      it 'with association=' do
        book = book_model.create title: 'The Hobbit', description: 'A book about a hobbit', published_at: Time.now
        book.publisher = publisher
        expect(book.publisher_id).to eq(publisher.id)
      end

      context 'with unsaved association' do
        it 'with build_association' do
          book = book_model.create title: 'The Hobbit', description: 'A book about a hobbit', published_at: Time.now
          book.build_publisher title: 'Boki', description: 'A book publisher'
          expect(book.publisher.title).to eq('Boki')
        end

        context 'saves' do
          it 'with build_association' do
            book = book_model.create title: 'The Hobbit', description: 'A book about a hobbit', published_at: Time.now
            book.build_publisher title: 'Boki', description: 'A book publisher'
            book.save
            expect(book.publisher_id).to_not be_nil
            expect(book.publisher.title).to eq('Boki')
            book = book_model.find(book.id)
            expect(book.publisher.title).to eq('Boki')
          end
          
          it 'unless invalid' do
            book = book_model.create title: "The Hobbit", description: 'A book about a hobbit', published_at: Time.now
            book.build_publisher title: nil, description: 'A book publisher'
            expect{book.save}.to raise_error("Record is invalid")
            expect(book.publisher_id).to be_nil
          end
        end

      end
    end

  end

end