module Stretchy
    module Attributes
        module Type
            class Keyword < ActiveModel::Type::String # :nodoc:
                def type
                    :keyword
                end
            end
        end
    end
end