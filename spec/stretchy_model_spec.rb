require 'spec_helper'
require 'models/with_validations'
require 'support/behaves_like_stretchy_model'

describe StretchyModel do

  it_behaves_like 'a stretchy model', ModelWithValidations
  it_behaves_like 'CRUD', ModelWithValidations, {name: "hello", age: 30, tags: ["hello", "world"], data: {name: "hello", age: 30}, agreed: true}, {name: "goodbye"}

end