module Stretchy::Attributes::Type
  # The KnnVector attribute type.
  #
  # Defines an OpenSearch `knn_vector` field for approximate k-NN search.
  # See https://docs.opensearch.org/latest/mappings/supported-field-types/knn-vector/
  #
  # ### Parameters
  #
  # - `dimension`: The number of dimensions in the vector.
  # - `data_type`: `float` (default), `half_float`, `byte` or `binary`.
  # - `space_type`: The distance function, such as `l2` or `cosinesimil`.
  # - `mode`: `in_memory` (default) or `on_disk`.
  # - `compression_level`: `1x`, `2x`, `4x`, `8x`, `16x` or `32x`.
  # - `method`: The ANN algorithm, as a Hash of `name`, `space_type`, `engine` and `parameters`.
  # - `model_id`: A trained model, for methods that need training.
  #
  # ---
  #
  # ### Examples
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :my_vector, :knn_vector, dimension: 384, space_type: 'cosinesimil', mode: 'on_disk', compression_level: '32x'
  #   end
  # ```
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :my_vector, :knn_vector, dimension: 384, method: { name: 'hnsw', space_type: 'l2', engine: 'faiss', parameters: { ef_construction: 100, m: 16 } }
  #   end
  # ```
  #
  class KnnVector < Stretchy::Attributes::Type::Base
      OPTIONS = [:dimension, :data_type, :space_type, :mode, :compression_level, :method, :model_id]

      def type
        :knn_vector
      end

  end
end