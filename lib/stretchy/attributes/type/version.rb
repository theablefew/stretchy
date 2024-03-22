module Stretchy::Attributes::Type
  # The Version attribute type
  #
  # This class is used to define a version attribute for a model. This field type is used for software versions following the Semantic Versioning rules.
  #
  # ### Parameters
  #
  # - `type:` `:version`.
  # - `options:` The Hash of options for the attribute.
  #    - `:meta:` The Hash of metadata about the field.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a version attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :software_version, :version
  #   end
  # ```
  #
  class Version < Stretchy::Attributes::Type::Base
    OPTIONS = [:meta]

    def type
      :version
    end
  end
end