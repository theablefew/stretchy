module Stretchy::Attributes::Type::Range
  # Public: Defines an integer_range attribute for the model.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :age_range, :integer_range
  #   end
  #
  # Returns nothing.
  class IntegerRange < Base
    def type
      :integer_range
    end
  end
end