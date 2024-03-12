module Stretchy
    module Attributes
        module Type
            class Hash < ActiveModel::Type::Value # :nodoc:
                def type
                    :hash
                end

                private

                def cast_value(value)
                    Elasticsearch::Model::HashWrapper[value]
                end
            end
        end
    end
end