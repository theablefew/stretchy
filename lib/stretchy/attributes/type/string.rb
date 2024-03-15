module Stretchy::Attributes::Type
  class String < Stretchy::Attributes::Type::Text # :nodoc:
    def type
      :string
    end
  end
end