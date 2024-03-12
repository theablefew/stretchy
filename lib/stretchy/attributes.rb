module Stretchy
  module Attributes

    def self.register!
      ActiveModel::Type.register(:array, Stretchy::Attributes::Type::Array)
      ActiveModel::Type.register(:hash, Stretchy::Attributes::Type::Hash)
      ActiveModel::Type.register(:keyword, Stretchy::Attributes::Type::Keyword)
      ActiveModel::Type.register(:text, Stretchy::Attributes::Type::Text)
    end
  end
end