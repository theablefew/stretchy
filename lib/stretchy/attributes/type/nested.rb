module Stretchy::Attributes::Type
  # Public: Defines a nested attribute for the model.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :dynamic - The String indicating if new properties should be added dynamically to an existing nested object. Can be 'true', 'false', or 'strict'. Defaults to 'true'.
  #        :properties - The Hash of fields within the nested object, which can be of any data type, including nested.
  #        :include_in_parent - The Boolean indicating if all fields in the nested object are also added to the parent document as standard fields. Defaults to false.
  #        :include_in_root - The Boolean indicating if all fields in the nested object are also added to the root document as standard fields. Defaults to false.
  #
  # Examples
  #
  #   class MyModel
  #     include StretchyModel
  #     attribute :metadata, :nested, dynamic: 'strict', include_in_parent: true
  #   end
  #
  # Returns nothing.
  class Nested < Stretchy::Attributes::Type::Base
    OPTIONS = [:dynamic, :properties, :include_in_parent, :include_in_root]

    def type
      :nested
    end
  end
end