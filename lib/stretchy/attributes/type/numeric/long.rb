module Stretchy::Attributes::Type::Numeric
  # The Long attribute type
  #
  # This class is used to define a long attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold long integer values.
  #
  # ### Parameters
  #
  # - `type:` `:long`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a long attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :population, :long
  #   end
  # ```
  #
  class Long < Base
    def type
      :long
    end
  end
end