module Stretchy::Attributes::Type
  # Public: Defines a shape attribute for the model. This field type is used for complex shapes.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :orientation - The String indicating how to interpret vertex order for polygons / multipolygons. Can be 'right', 'ccw', 'counterclockwise', 'left', 'cw', 'clockwise'. Defaults to 'ccw'.
  #        :ignore_malformed - The Boolean indicating if malformed GeoJSON or WKT shapes should be ignored. Defaults to false.
  #        :ignore_z_value - The Boolean indicating if the z value of three dimension points should be ignored. Defaults to true.
  #        :coerce - The Boolean indicating if unclosed linear rings in polygons will be automatically closed. Defaults to false.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :boundary, :shape, orientation: 'cw'
  #   end
  #
  # Returns nothing.
  class Shape < Stretchy::Attributes::Type::Base
    OPTIONS = [:orientation, :ignore_malformed, :ignore_z_value, :coerce]

    def type
      :shape
    end
  end
end