require 'spec_helper'
require 'support/behaves_like_stretchy_model'

describe StretchyModel do

  TestModel = Class.new(StretchyModel) do
    attribute :name, :text
    attribute :age, :integer
    attribute :tags, :array
    attribute :data, :hash
    attribute :published_at, :datetime
    attribute :agreed, :boolean

    validates :name, presence: true
    validates :age,  numericality: { only_integer: true, greater_than: 21}
    validates :tags, length: { minimum: 1 }
    validates :data, presence: true
    validates :agreed, acceptance: true
  end

  let(:model) { TestModel }

  it_behaves_like 'a stretchy model', TestModel
  it_behaves_like 'CRUD', TestModel, {name: "hello", age: 30, tags: ["hello", "world"], data: {name: "hello", age: 30}, agreed: true}, {name: "goodbye"}
end