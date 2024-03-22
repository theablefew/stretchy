module Stretchy::Attributes::Type
  # The Flattened attribute type
  #
  # This class is used to define a flattened attribute for a model. It provides support for the Elasticsearch flattened data type, which is a type of data type that can hold an entire JSON object as a single field.
  #
  # ### Parameters
  #
  # - `type:` `:flattened`.
  # - `options:` The Hash of options for the attribute.
  #    - `:depth_limit:` The Integer maximum allowed depth of the flattened object field. Defaults to 20.
  #    - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.
  #    - `:eager_global_ordinals:` The Boolean indicating if global ordinals should be loaded eagerly on refresh. Defaults to false.
  #    - `:ignore_above:` The Integer limit for the length of leaf values. Values longer than this limit will not be indexed. By default, there is no limit.
  #    - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
  #    - `:index_options:` The String indicating what information should be stored in the index for scoring purposes. Defaults to 'docs'.
  #    - `:null_value:` The String value to be substituted for any explicit null values. Defaults to null.
  #    - `:similarity:` The String scoring algorithm or similarity to be used. Defaults to 'BM25'.
  #    - `:split_queries_on_whitespace:` The Boolean indicating if full text queries should split the input on whitespace. Defaults to false.
  #    - `:time_series_dimensions:` The Array of Strings indicating the fields inside the flattened object that are dimensions of the time series.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a flattened attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :metadata, :flattened, depth_limit: 10, index_options: 'freqs'
  #   end
  # ```
  #
  class Flattened < Stretchy::Attributes::Type::Base
    OPTIONS = [:depth_limit, :doc_values, :eager_global_ordinals, :ignore_above, :index, :index_options, :null_value, :similarity, :split_queries_on_whitespace, :time_series_dimensions]

    def type
      :flattened
    end
  end
end