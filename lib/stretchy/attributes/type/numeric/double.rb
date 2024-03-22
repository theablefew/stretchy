module Stretchy::Attributes::Type::Numeric
  # The Double attribute type
  #
  # This class is used to define a double attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold double-precision 64-bit IEEE 754 floating point values.
  #
  # ### Parameters
  #
  # - `type:` `:double`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a double attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :rating, :double
  #   end
  # ```
  #
  class Double < Base
    def type
      :double
    end
  end
end