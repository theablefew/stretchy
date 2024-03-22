module Stretchy::Attributes::Type::Numeric
  # The Short attribute type
  #
  # This class is used to define a short attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold short integer values.
  #
  # ### Parameters
  #
  # - `type:` `:short`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a short attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :short_number, :short
  #   end
  # ```
  #
  class Short < Base
    def type
      :short
    end
  end
end