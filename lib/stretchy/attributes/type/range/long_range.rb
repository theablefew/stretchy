module Stretchy::Attributes::Type::Range
  # Public: Defines a long_range attribute for the model.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :population_range, :long_range
  #   end
  #
  # Returns nothing.
  class LongRange < Base
    def type
      :long_range
    end
  end
end