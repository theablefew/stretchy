require 'spec_helper'
require 'models/test_model'
require 'support/behaves_like_stretchy_model'

describe TestModel do

  it_behaves_like 'a stretchy model', described_class
  it_behaves_like 'CRUD', described_class, {name: "hello", age: 30, tags: ["hello", "world"], data: {name: "hello", age: 30}, agreed: true}, {name: "goodbye"}

end