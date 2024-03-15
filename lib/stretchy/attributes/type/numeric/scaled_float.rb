module Stretchy::Attributes::Type::Numeric

  # Public: Defines a scaled_float attribute for the model.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :scaling_factor - The Integer scaling factor to use when encoding values. This parameter is required.
  #
  # Examples
  #
  #   class MyModel
  #     include StretchyModel
  #     attribute :rating, :scaled_float, scaling_factor: 10
  #   end
  #
  # Returns nothing.
  class ScaledFloat < Base
    OPTIONS = Base::OPTIONS + [:scaling_factor]

    def type
      :scaled_float
    end
  end
end