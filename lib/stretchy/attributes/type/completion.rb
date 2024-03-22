module Stretchy::Attributes::Type
  # Completion attribute type for Elasticsearch completion suggester.
  #
  # This class is used to define a completion attribute for a model. It provides support for the Elasticsearch completion suggester, which is a type of suggester that provides auto-complete functionality.
  #
  # ### Parameters
  #
  # - `analyzer:` The String index analyzer to use. Defaults to 'simple'.
  # - `search_analyzer:` The String search analyzer to use. Defaults to the value of `analyzer`.
  # - `preserve_separators:` The Boolean indicating if separators should be preserved. Defaults to true.
  # - `preserve_position_increments:` The Boolean indicating if position increments should be enabled. Defaults to true.
  # - `max_input_length:` The Integer limit for the length of a single input. Defaults to 50.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a completion attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :name, :completion, analyzer: 'simple', max_input_length: 100
  #   end
  # ```
  #
  class Completion < Stretchy::Attributes::Type::Base
    OPTIONS = [:analyzer, :search_analyzer, :preserve_separators, :preserve_position_increments, :max_input_length]
    attr_reader *OPTIONS
    def type
      :completion
    end
  end
end