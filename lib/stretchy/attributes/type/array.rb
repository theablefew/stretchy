module Stretchy::Attributes::Type
  class Array < Stretchy::Attributes::Type::Base # :nodoc:
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