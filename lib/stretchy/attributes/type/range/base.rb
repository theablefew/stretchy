module Stretchy::Attributes::Type::Range
  # The Base class for range attribute types
  #
  # This class is used to define a base for range attribute types for a model. It provides support for the Elasticsearch range data types, which are types of data that can hold range of values.
  #
  # ### Parameters
  #
  # - `options:` The Hash of options for the attribute.
  #    - `:coerce:` The Boolean indicating if strings should be converted to numbers and fractions truncated for integers. Defaults to true.
  #    - `:index:` The Boolean indicating if the field should be quickly searchable. Defaults to true.
  #    - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a range attribute
  #
  # ```ruby
  #   class MyModel < Stretchy::Record
  #     attribute :age_range, :integer_range, coerce: false
  #   end
  # ```
  #
  class Base < Stretchy::Attributes::Type::Base #:nodoc:
    OPTIONS = [:coerce, :index, :store]

    def type
      raise NotImplementedError, "You must use one of the range types: integer_range, float_range, long_range, double_range, date_range, or ip_range."
    end
  end
end