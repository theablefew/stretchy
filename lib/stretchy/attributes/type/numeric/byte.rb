module Stretchy::Attributes::Type::Numeric
  # The Byte attribute type
  #
  # This class is used to define a byte attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold byte values.
  #
  # ### Parameters
  #
  # - `type:` `:byte`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a byte attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :data, :byte
  #   end
  # ```
  #
  class Byte < Base
    def type
      :byte
    end
  end
end