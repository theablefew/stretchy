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
          class SparseVector < ActiveModel::Type::Value

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