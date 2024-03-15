# Public: Defines a dense vector attribute for the model.
#
# name - The Symbol name of the attribute.
# opts - The Hash options used to refine the attribute (default: {}):
#        :element_type - The String data type used to encode vectors. Can be 'float' or 'byte'.
#                        'float' indexes a 4-byte floating-point value per dimension.
#                        'byte' indexes a 1-byte integer value per dimension.
#                        Vectors using 'byte' require dimensions with integer values between -128 to 127.
#        :dims - The Integer number of vector dimensions. Can’t exceed 4096.
#                If not specified, it will be set to the length of the first vector added to the field.
#        :index - The Boolean indicating if you can search this field using the kNN search API (default: true).
#        :similarity - The String vector similarity metric to use in kNN search. Can be 'l2_norm', 'dot_product', 'cosine', or 'max_inner_product'.
#                      This parameter can only be specified when :index is true.
#        :index_options - The Hash that configures the kNN indexing algorithm. Can only be specified when :index is true.
#                         :type - The String type of kNN algorithm to use. Can be either 'hnsw' or 'int8_hnsw'.
#                         :m - The Integer number of neighbors each node will be connected to in the HNSW graph.
#                         :ef_construction - The Integer number of candidates to track while assembling the list of nearest neighbors for each new node.
#                         :confidence_interval - The Float confidence interval to use when quantizing the vectors. Only applicable to 'int8_hnsw' index types.
#
# Examples
#
#   class MyModel
#     include StretchyModel
#     attribute :vector_embeddings, :dense_vector, element_type: 'float', dims: 3
#   end
#
# Returns nothing.
module Stretchy
  module Attributes
      module Type
          class DenseVector < Stretchy::Attributes::Type::Base
              OPTIONS = [:element_type, :dims, :index, :similarity, :index_options]
              attr_reader *OPTIONS 

              def initialize(**args)  
                args.each do |k, v|
                  instance_variable_set("@#{k}", v) if OPTIONS.include?(k)
                  args.delete(k)
                end
                super
              end

              def type
                :dense_vector
              end

              def mappings(name) 
                options = {type: type}
                OPTIONS.each { |_| options[_] = self.send(_) }
                {
                  properties: {
                    "#{name}.tokens": options
                  }
                }.as_json
              end
          end
      end
  end
end