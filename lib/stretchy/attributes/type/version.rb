module Stretchy::Attributes::Type
  # Public: Defines a version attribute for the model. This field type is used for software versions following the Semantic Versioning rules.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :meta - The Hash of metadata about the field.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :software_version, :version
  #   end
  #
  # Returns nothing.
  class Version < Stretchy::Attributes::Type::Base
    OPTIONS = [:meta]

    def type
      :version
    end
  end
end