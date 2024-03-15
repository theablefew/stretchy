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
                    args.delete(k)
                  end
                end
                super
              end
      
              def mappings(name)
                options = {type: type}
                self.class::OPTIONS.each { |option| options[option] = send(option) unless send(option).nil? }
                { name => options }.as_json
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