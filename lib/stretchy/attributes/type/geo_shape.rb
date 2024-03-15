module Stretchy::Attributes::Type
  # Public: Defines a geo_shape attribute for the model.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :orientation - The String default orientation for the field’s WKT polygons. Can be 'right', 'counterclockwise', 'ccw', 'left', 'clockwise', or 'cw'. Defaults to 'right'.
  #        :ignore_malformed - The Boolean indicating if malformed GeoJSON or WKT shapes should be ignored. Defaults to false.
  #        :ignore_z_value - The Boolean indicating if three dimension points should be accepted but only latitude and longitude values should be indexed. Defaults to true.
  #        :coerce - The Boolean indicating if unclosed linear rings in polygons should be automatically closed. Defaults to false.
  #        :index - The Boolean indicating if the field should be quickly searchable. Defaults to true.
  #        :doc_values - The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.
  #
  # Examples
  #
  #   class MyModel
  #     include StretchyModel
  #     attribute :boundary, :geo_shape, orientation: 'left', coerce: true
  #   end
  #
  # Returns nothing.
  class GeoShape < Stretchy::Attributes::Type::Base
    OPTIONS = [:orientation, :ignore_malformed, :ignore_z_value, :coerce, :index, :doc_values]

    def type
      :geo_shape
    end
  end
end