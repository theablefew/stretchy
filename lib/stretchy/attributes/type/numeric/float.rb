module Stretchy::Attributes::Type::Numeric
  # The Float attribute type
  #
  # This class is used to define a float attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold single-precision 32-bit IEEE 754 floating point values.
  #
  # ### Parameters
  #
  # - `type:` `:float`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a float attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :rating, :float
  #   end
  # ```
  #
  class Float < Base
    def type
      :float
    end
  end
end