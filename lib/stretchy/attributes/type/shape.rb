module Stretchy::Attributes::Type
  # The Shape attribute type
  #
  # This class is used to define a shape attribute for a model. It provides support for the Elasticsearch shape data type, which is a type of data type that can hold complex shapes represented as GeoJSON or WKT.
  #
  # ### Parameters
  #
  # - `type:` `:shape`.
  # - `options:` The Hash of options for the attribute.
  #    - `:orientation:` The String indicating how to interpret vertex order for polygons / multipolygons. Can be 'right', 'ccw', 'counterclockwise', 'left', 'cw', 'clockwise'. Defaults to 'ccw'.
  #    - `:ignore_malformed:` The Boolean indicating if malformed GeoJSON or WKT shapes should be ignored. Defaults to false.
  #    - `:ignore_z_value:` The Boolean indicating if the z value of three dimension points should be ignored. Defaults to true.
  #    - `:coerce:` The Boolean indicating if unclosed linear rings in polygons will be automatically closed. Defaults to false.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a shape attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :boundary, :shape, orientation: 'cw'
  #   end
  # ```
  #
  class Shape < Stretchy::Attributes::Type::Base
    OPTIONS = [:orientation, :ignore_malformed, :ignore_z_value, :coerce]

    def type
      :shape
    end
  end
end