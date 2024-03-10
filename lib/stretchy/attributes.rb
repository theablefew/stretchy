module Stretchy
  module Attributes

    def self.register!
      ActiveModel::Type.register(:array, ActiveModel::Type::Array)
      ActiveModel::Type.register(:hash, ActiveModel::Type::Hash)
      ActiveModel::Type.register(:keyword, Stretchy::Attributes::Type::Keyword)
    end
  end
end