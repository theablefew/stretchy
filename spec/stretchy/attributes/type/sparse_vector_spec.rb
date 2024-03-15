require 'spec_helper'

describe "SparseVector" do

  let(:model_class) {
    class SparseModel < Stretchy::Record
      attribute :vector, :sparse_vector
    end
    SparseModel
  }

  it 'has a type' do
    vector_attribute = model_class.attribute_types["vector"]
    expect(vector_attribute.type).to eq(:sparse_vector)
  end

  it 'has mappings' do
    vector_attribute = model_class.attribute_types["vector"]
    mappings = vector_attribute.mappings("vector")
    expect(mappings).to eq({
      properties: {
        "vector.tokens": {
          type: :sparse_vector
        }
      }
    }.as_json)
  end

end