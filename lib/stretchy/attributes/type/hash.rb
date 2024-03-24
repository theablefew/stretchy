module Stretchy::Attributes::Type
  # The Hash attribute type
  #
  # This class is used to define a hash attribute for a model. It provides support for the Elasticsearch object data type, which is a type of data type that can hold JSON objects.
  #
  # ### Parameters
  #
  # - `type:` `:hash`.
  # - `options:` The Hash of options for the attribute.
  #    - `:dynamic:` The String indicating if new properties should be added dynamically to an existing object. Can be 'true', 'runtime', 'false', or 'strict'. Defaults to 'true'.
  #    - `:enabled:` The Boolean indicating if the JSON value for the object field should be parsed and indexed. Defaults to true.
  #    - `:subobjects:` The Boolean indicating if the object can hold subobjects. Defaults to true.
  #    - `:properties:` The Hash of fields within the object, which can be of any data type, including object.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a hash attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :metadata, :hash, dynamic: 'strict', subobjects: false
  #   end
  # ```
  #
  class Hash < Stretchy::Attributes::Type::Base
    OPTIONS = [:dynamic, :enabled, :subobjects, :properties]

    def type
      :hash
    end

    def type_for_database
      :object
    end

    def mappings(name)
      options = {type: type_for_database}
      OPTIONS.each { |option| options[option] = send(option) unless send(option).nil? }
      { name => options }.as_json
    end

    def keyword_field?
      true
    end

    private

    def cast_value(value)
      Elasticsearch::Model::HashWrapper[value]
    end
  end
end