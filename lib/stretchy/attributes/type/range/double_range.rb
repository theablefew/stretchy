module Stretchy::Attributes::Type::Range
  # Public: Defines a double_range attribute for the model.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :weight_range, :double_range
  #   end
  #
  # Returns nothing.
  class DoubleRange < Base

    def type
      :double_range
    end
  end
end