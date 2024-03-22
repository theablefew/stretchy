module Stretchy::Attributes::Type
  # The Array attribute type
  #
  # This class is used to define an array attribute for a model. It provides support for the Elasticsearch array data type, which is a type of data type that can hold multiple values.
  #
  # ### Parameters
  #
  # - `type:` `:array`.
  # - `options:` The Hash of options for the attribute.
  #    - `:data_type:` The Symbol representing the data type for the array. Defaults to `:text`.
  #    - `:fields:` The Boolean indicating if fields should be included in the mapping. Defaults to `true`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define an array attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :tags, :array, data_type: :text
  #   end
  # ```
  #
  class Array < Stretchy::Attributes::Type::Base
    OPTIONS = [:data_type, :fields]
    def type
      :array
    end

    def type_for_database
      data_type || :text
    end

    def mappings(name)
      options = {type: type_for_database}
      self.class::OPTIONS.each { |option| options[option] = send(option) unless send(option).nil? }
      options.delete(:fields) if fields == false
      options[:fields] = {keyword: {type: :keyword, ignore_above: 256}} if type_for_database == :text && fields.nil?
      { name => options }.as_json
    end
  end
end