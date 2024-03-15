# Public: Defines a binary attribute for the model.
#
# name - The Symbol name of the attribute.
# opts - The Hash options used to refine the attribute (default: {}):
#        :doc_values - The Boolean indicating if the field should be stored on disk in a column-stride fashion.
#                      This allows it to be used later for sorting, aggregations, or scripting. Defaults to false.
#        :store - The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
#
# Examples
#
#   class MyModel
#     include StretchyModel
#     attribute :name, :binary, doc_values: true, store: true
#   end
#
# Returns nothing.
module Stretchy
    module Attributes
        module Type
            class Binary < ActiveModel::Type::Value
                OPTIONS = [:doc_values, :store]
                attr_reader *OPTIONS 

                def initialize(**args)  
                  args.each do |k, v|
                    instance_variable_set("@#{k}", v) if OPTIONS.include?(k)
                    args.delete(k)
                  end
                  super
                end

                def type
                    :binary
                end


                def mappings(name) 
                  options = {type: type}
                  OPTIONS.each { |_| options[_] = self.send(_) }
                  { name => options }.as_json
                end
            end
        end
    end
end