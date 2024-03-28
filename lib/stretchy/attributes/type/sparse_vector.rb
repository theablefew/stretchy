module Stretchy
  module Attributes
      module Type
          # The SparseVector attribute type
          #
          # This class is used to define a sparse_vector attribute for a model. It provides support for the Elasticsearch sparse_vector data type, which is a type of data type that can hold sparse vectors of float values.
          #
          # ### Parameters
          #
          # - `type:` `:sparse_vector`.
          # - `options:` The Hash of options for the attribute. This type does not have any specific options.
          #
          # ---
          #
          # ### Examples
          #
          # #### Define a sparse_vector attribute
          #
          # ```ruby
          #   class MyModel < StretchyModel
          #     attribute :ml, :sparse_vector
          #   end
          # ```
          #
          class SparseVector < Stretchy::Attributes::Type::Base

              def type
                :sparse_vector
              end

              def mappings(name) 
                {
                  "#{name}.tokens": {
                      type: "sparse_vector"
                  }
                }.as_json
              end
          end
      end
  end
end