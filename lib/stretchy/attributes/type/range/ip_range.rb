module Stretchy::Attributes::Type::Range
  # Public: Defines an ip_range attribute for the model.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :ip_range, :ip_range
  #   end
  #
  # Returns nothing.
  class IpRange < Base
    def type
      :ip_range
    end
  end
end