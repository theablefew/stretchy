module Stretchy::Attributes::Type::Range
  # Public: Defines a date_range attribute for the model.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :birth_date_range, :date_range
  #   end
  #
  # Returns nothing.
  class DateRange < Base

    def type
      :date_range
    end
  end
end
