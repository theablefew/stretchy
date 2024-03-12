require 'spec_helper'

describe Stretchy::Associations do
  context 'has_many' do
    let(:book_model) {
      class Book < Stretchy::Record
        attribute :title, :keyword
        attribute :description, :string
        attribute :user_id, :keyword

        # belongs_to :user

        validates_presence_of :title
      end
      Book
    }

    let(:user_model) {
      class User < Stretchy::Record
        attribute :name, :keyword
        attribute :email, :string

        has_many :books

        validates_presence_of :name
      end
      User
    }

    let(:user) { user_model.create name: 'John Doe', email: 'bookclub@john.com' }
    let(:book) { book_model.create title: 'The Hobbit', description: 'A book about a hobbit'}

    before(:each) do
      book_model
    end

    it 'responds_to has_many' do
      expect(user_model).to respond_to(:has_many)
    end

    it 'reflects the association' do
      user = user_model.create name: 'John Doe', email: 'john.doe@example.com'
      expect(user.association_reflection(:books)).to be_a Stretchy::Relation
    end

    context 'configuration' do
      context 'defaults' do
        let(:options) { user_model.class_variable_get(:@@_association_options) }
        it 'sets the foreign key' do
          expect(options[:books][:foreign_key]).to eq('user_id')
        end
        it 'sets the primary key' do
          expect(options[:books][:primary_key]).to eq('id')
        end
        it 'sets the class name' do
          expect(options[:books][:class_name]).to eq(:book)
        end
      end
    end

    it 'returns a collection' do
      user = user_model.create name: 'John Doe', email: 'goat@me.com'
      expect(user.books).to be_a Stretchy::Relation
    end

    context 'it assigns the association' do
      it 'with id' do
        new_user = user_model.create name: 'John Doe', email: 'john.doe@example.com', book_ids: [book.id]
        expect(new_user.book_ids).to include(book.id)
        expect(new_user.books.pluck(:id)).to include(book.id)
      end

      it 'with object' do
        new_user = user_model.create name: 'John Doe', email: 'john.doe@example.com', books: [book]
        expect(new_user.books.pluck(:id)).to include(book.id)
        expect(book_model.find(book.id).user_id).to eq(new_user.id)
      end

      it 'with association=' do
        new_user = user_model.create name: 'John Doe', email: 'john.doe@example.com'
        new_user.books = [book]
        new_user.save
        expect(new_user.book_ids).to include(book.id)
        expect(book_model.find(book.id).user_id).to eq(new_user.id)
      end
    end
  end
end