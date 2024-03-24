require 'spec_helper'
require 'models/test_model'
require 'support/behaves_like_stretchy_model'

describe TestModel do

  after(:all) do
    described_class.delete_index! if described_class.index_exists?
  end

  it_behaves_like 'a stretchy model', described_class
  it_behaves_like 'CRUD', described_class, {name: "hello", age: 30, tags: ["hello", "world"], data: {name: "hello", age: 30}, agreed: true}, {name: "goodbye"}



end