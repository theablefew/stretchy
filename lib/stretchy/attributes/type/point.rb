module Stretchy::Attributes::Type
  # The Point attribute type
  #
  # This class is used to define a point attribute for a model. It provides support for the Elasticsearch point data type, which is
  #  a type of data type that can hold geographical points (latitude and longitude).
  #
  # ### Parameters
  #
  # - `type:` `:point`.
  # - `options:` The Hash of options for the attribute.
  #    - `:ignore_malformed:` The Boolean indicating if malformed points should be ignored. Defaults to false.
  #    - `:ignore_z_value:` The Boolean indicating if the z value of three dimension points should be ignored. Defaults to true.
  #    - `:null_value:` The Point value to be substituted for any explicit null values. Defaults to null.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a point attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :location, :point, ignore_malformed: true
  #   end
  # ```
  #
  class Point < Stretchy::Attributes::Type::Base
    OPTIONS = [:ignore_malformed, :ignore_z_value, :null_value]

    def type
      :point
    end
  end
end