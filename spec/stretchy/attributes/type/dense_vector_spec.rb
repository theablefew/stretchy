require 'spec_helper'
# require 'models/test_model'

describe 'DenseVector' do

let(:model_class) {
  class DenseModel < Stretchy::Record
    attribute :vector, :dense_vector, 
        element_type: 'float', 
        dims: 3, 
        index: true, 
        similarity: 'l2_norm', 
        index_options: {
          type: 'hnsw', 
          m: 16, 
          ef_construction: 200
        }
  end
  DenseModel
}

  it 'allows options' do
    vector_attribute = model_class.attribute_types["vector"]
    expect(vector_attribute.element_type).to eq('float')
    expect(vector_attribute.dims).to eq(3)
    expect(vector_attribute.index).to eq(true)
    expect(vector_attribute.similarity).to eq('l2_norm')
    expect(vector_attribute.index_options).to eq({type: 'hnsw', m: 16, ef_construction: 200})
  end

  it 'has a type' do
    vector_attribute = model_class.attribute_types["vector"]
    expect(vector_attribute.type).to eq(:dense_vector)
  end

  it 'has mappings' do

    vector_attribute = model_class.attribute_types["vector"]
    mappings = vector_attribute.mappings("vector")
    expect(mappings).to eq({
      properties: {
        "vector.tokens": {
          type: :dense_vector,
          dims: 3,
          element_type: "float",
          index: true,
          similarity: "l2_norm",
          index_options: {
            type: "hnsw",
            m: 16,
            ef_construction: 200
          }
        }
      }
    }.as_json)
  end

end