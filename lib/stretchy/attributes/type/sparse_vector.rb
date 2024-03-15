# 
# attribute :ml, :sparse_vector
# 
# {
#   "mappings": {
#     "properties": {
#       "ml.tokens": {
#         "type": "sparse_vector"
#       }
#     }
#   }
# }
#


module Stretchy
  module Attributes
      module Type
          class SparseVector < Stretchy::Attributes::Type::Base

              def type
                :sparse_vector
              end

              def mappings(name) 
                  {
                    properties: {
                      "#{name}.tokens": {
                          type: "sparse_vector"
                      }
                    }
                }.as_json
              end
          end
      end
  end
end