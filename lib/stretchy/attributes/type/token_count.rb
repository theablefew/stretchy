module Stretchy::Attributes::Type
  # Public: Defines a token_count attribute for the model. This field type is used for counting the number of tokens in a string.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :analyzer - The String analyzer to be used to analyze the string value. Required.
  #        :enable_position_increments - The Boolean indicating if position increments should be counted. Defaults to true.
  #        :doc_values - The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.
  #        :index - The Boolean indicating if the field should be searchable. Defaults to true.
  #        :null_value - The Numeric value to be substituted for any explicit null values. Defaults to null.
  #        :store - The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :description_token_count, :token_count, analyzer: 'standard'
  #   end
  #
  # Returns nothing.
  class TokenCount < Stretchy::Attributes::Type::Base
    OPTIONS = [:analyzer, :enable_position_increments, :doc_values, :index, :null_value, :store]

    def type
      :token_count
    end
  end
end