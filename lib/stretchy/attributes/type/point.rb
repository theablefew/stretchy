module Stretchy::Attributes::Type
  # Public: Defines a point attribute for the model.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :ignore_malformed - The Boolean indicating if malformed points should be ignored. Defaults to false.
  #        :ignore_z_value - The Boolean indicating if the z value of three dimension points should be ignored. Defaults to true.
  #        :null_value - The Point value to be substituted for any explicit null values. Defaults to null.
  #
  # Examples
  #
  #   class MyModel
  #     include StretchyModel
  #     attribute :location, :point, ignore_malformed: true
  #   end
  #
  # Returns nothing.
  class Point < Stretchy::Attributes::Type::Base
    OPTIONS = [:ignore_malformed, :ignore_z_value, :null_value]

    def type
      :point
    end
  end
end