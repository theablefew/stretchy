module Stretchy::Attributes::Type::Range
  # The LongRange attribute type
  #
  # This class is used to define a long_range attribute for a model. It provides support for the Elasticsearch range data type, which is a type of data type that can hold range of long integer values.
  #
  # ### Parameters
  #
  # - `type:` `:long_range`.
  # - `options:` The Hash of options for the attribute.
  #    - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. This allows it to be used later for sorting, aggregations, or scripting. Defaults to true.
  #    - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
  #    - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
  #    - `:coerce:` The Boolean indicating if the field should automatically coerce the values to the data type. Defaults to true.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a long_range attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :population_range, :long_range
  #   end
  # ```
  #
  class LongRange < Base
    def type
      :long_range
    end
  end
end