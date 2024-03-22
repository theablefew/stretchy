module Stretchy::Attributes::Type
  # The TokenCount attribute type
  #
  # This class is used to define a token_count attribute for a model. It provides support for the Elasticsearch token_count data type, which is a type of data type that can count the number of tokens in a string.
  #
  # ### Parameters
  #
  # - `type:` `:token_count`.
  # - `options:` The Hash of options for the attribute.
  #    - `:analyzer:` The String analyzer to be used to analyze the string value. Required.
  #    - `:enable_position_increments:` The Boolean indicating if position increments should be counted. Defaults to true.
  #    - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.
  #    - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
  #    - `:null_value:` The Numeric value to be substituted for any explicit null values. Defaults to null.
  #    - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a token_count attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :description_token_count, :token_count, analyzer: 'standard'
  #   end
  # ```
  #
  class TokenCount < Stretchy::Attributes::Type::Base
    OPTIONS = [:analyzer, :enable_position_increments, :doc_values, :index, :null_value, :store]

    def type
      :token_count
    end
  end
end