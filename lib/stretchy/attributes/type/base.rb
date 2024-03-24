module Stretchy
    module Attributes
        module Type
            class Base < ActiveModel::Type::Value

              OPTIONS = []

              def initialize(**args)

                define_option_methods!

                args.each do |k, v|
                  if self.class::OPTIONS.include?(k)
                    instance_variable_set("@#{k}", v) 
                  end
                  args.delete(k)
                end
                super
              end

              def keyword_field?
                return false unless respond_to? :fields
                fields.present? && fields.include?(:keyword)
              end
      
              def mappings(name)
                options = {type: type_for_database}
                self.class::OPTIONS.each { |option| options[option] = send(option) unless send(option).nil? }
                { name => options }.as_json
              end

              def type_for_database
                type
              end

              private

              def define_option_methods!
                self.class::OPTIONS.each do |option|
                  define_singleton_method(option.to_sym) { instance_variable_get("@#{option}") }
                end
              end
            end
        end
    end
end