module Stretchy::Attributes::Type
  # The Semantic attribute type.
  #
  # Defines an OpenSearch `semantic` field, which generates embeddings at ingest and
  # query time from the model it names, without a separate ingest pipeline or
  # embedding field. OpenSearch 3.1 and later.
  # See https://docs.opensearch.org/latest/mappings/supported-field-types/semantic/
  #
  # ### Parameters
  #
  # - `model_id`: The model used to embed documents. Takes a model id, a model class or its class name as a Symbol.
  # - `search_model_id`: The model used to embed queries, when it differs from `model_id`.
  # - `raw_field_type`: The type of the field that stores the raw text. `text` by default.
  # - `semantic_info_field_name`: The name of the field that stores the embeddings.
  # - `chunking`: Splits long text into passages before embedding.
  # - `semantic_field_search_analyzer`: The analyzer for queries against a sparse model.
  # - `model_selection`: Picks the model from cluster settings instead of `model_id`.
  # - `dense_embedding_config`: Settings for the generated `knn_vector` field when the model is dense.
  # - `sparse_encoding_config`: Pruning settings for the generated sparse vector.
  # - `skip_existing_embedding`: Reuses the stored embedding when the text and model are unchanged.
  #
  # ---
  #
  # ### Examples
  #
  # ```ruby
  #   class Article < StretchyModel
  #     attribute :body, :semantic, model_id: :text_embedding_model
  #   end
  # ```
  #
  class Semantic < Stretchy::Attributes::Type::Base
    OPTIONS = [:model_id, :search_model_id, :raw_field_type, :semantic_info_field_name, :chunking,
               :semantic_field_search_analyzer, :model_selection, :dense_embedding_config,
               :sparse_encoding_config, :skip_existing_embedding]
    MODEL_OPTIONS = [:model_id, :search_model_id]

    def type
      :semantic
    end

    def mappings(name)
      options = super[name.to_s]
      MODEL_OPTIONS.each do |option|
        options[option.to_s] = Stretchy::MachineLearning::Resource.remote_id_for(send(option)) unless send(option).nil?
      end
      { name => options }.as_json
    end
  end
end
