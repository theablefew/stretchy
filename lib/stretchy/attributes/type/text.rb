module Stretchy
  module Attributes
      module Type
          # alias for ActiveModel::Type::String
          class Text < ActiveModel::Type::String
              def type
                  :text
              end
          end
      end
  end
end