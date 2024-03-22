module Stretchy::Attributes::Type::Numeric

  # The ScaledFloat attribute type
  #
  # This class is used to define a scaled_float attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold floating point values scaled by a fixed double precision factor.
  #
  # ### Parameters
  #
  # - `type:` `:scaled_float`.
  # - `options:` The Hash of options for the attribute.
  #    - `:scaling_factor:` The Integer scaling factor to use when encoding values. This parameter is required.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a scaled_float attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :rating, :scaled_float, scaling_factor: 10
  #   end
  # ```
  #
  class ScaledFloat < Base
    OPTIONS = Base::OPTIONS + [:scaling_factor]

    def type
      :scaled_float
    end
  end
end