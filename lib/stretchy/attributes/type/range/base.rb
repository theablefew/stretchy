module Stretchy::Attributes::Type::Range
  class Base < Stretchy::Attributes::Type::Base
    OPTIONS = [:coerce, :index, :store]

    def type
      raise NotImplementedError, "You must use one of the range types: integer_range, float_range, long_range, double_range, date_range, or ip_range."
    end
  end
end