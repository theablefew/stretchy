require 'spec_helper'

describe "KnnVector" do

  let(:model_class) {
    class KnnModel < StretchyModel
      attribute :vector, :knn_vector
    end
    KnnModel
  }

  it 'has a type' do
    vector_attribute = model_class.attribute_types["vector"]
    expect(vector_attribute.type).to eq(:knn_vector)
  end

  it 'has mappings' do
    vector_attribute = model_class.attribute_types["vector"]
    mappings = vector_attribute.mappings("vector")
    expect(mappings).to eq(
      {
        "vector": {
          type: :knn_vector
        }
      }.as_json
    )
  end

  context 'with options' do
    it 'has mappings' do
      model_class.attribute :embeddings, :knn_vector, dimension: 3, method: 'cosine'
      vector_attribute = model_class.attribute_types["embeddings"]
      mappings = vector_attribute.mappings("embeddings")
      expect(mappings).to eq(
        {
          "embeddings": {
            type: :knn_vector,
            dimension: 3,
            method: 'cosine'
          }
        }.as_json
      )
    end
  end



end