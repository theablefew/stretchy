module Stretchy::Attributes::Type::Range
  # Public: Defines a float_range attribute for the model.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :rating_range, :float_range
  #   end
  #
  # Returns nothing.
  class FloatRange < Base
    def type
      :float_range
    end
  end
end