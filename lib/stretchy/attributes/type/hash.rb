module Stretchy::Attributes::Type
  # Public: Defines a hash attribute for the model.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :dynamic - The String indicating if new properties should be added dynamically to an existing object. Can be 'true', 'runtime', 'false', or 'strict'. Defaults to 'true'.
  #        :enabled - The Boolean indicating if the JSON value for the object field should be parsed and indexed. Defaults to true.
  #        :subobjects - The Boolean indicating if the object can hold subobjects. Defaults to true.
  #        :properties - The Hash of fields within the object, which can be of any data type, including object.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :metadata, :hash, dynamic: 'strict', subobjects: false
  #   end
  #
  # Returns nothing.
  class Hash < Stretchy::Attributes::Type::Base
    OPTIONS = [:dynamic, :enabled, :subobjects, :properties]

    def type
      :hash
    end

    private

    def cast_value(value)
      Elasticsearch::Model::HashWrapper[value]
    end
  end
end