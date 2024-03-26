require 'spec_helper'
require 'models/test_model'

describe Stretchy::Relations::QueryMethods::None do
  let(:model) { TestModel }

  it 'returns a null relation' do
    expect(model.none.class).to eq("#{model.name}::Stretchy_Relation".constantize)
  end
end