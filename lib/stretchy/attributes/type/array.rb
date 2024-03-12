module Stretchy
    module Attributes
        module Type

            class Array < ActiveModel::Type::Value # :nodoc:

                def type
                    :array
                end

            end

        end
    end
end