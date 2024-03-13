module Stretchy
  module Attributes
    extend ActiveSupport::Concern

    def [](attribute)
      self.send(attribute)
    end

    def []=(attribute, value)
        self.send("#{attribute}=", value)
    end

    def inspect
      "#<#{self.class.name} #{attributes.map { |k,v| "#{k}: #{v.blank? ? 'nil' : v}" }.join(', ')}>"
    end

    class_methods do
      def inspect
        "#<#{self.name} #{attribute_types.map { |k,v| "#{k}: #{v.type}" }.join(', ')}>"
      end
    end

    def self.register!
      ActiveModel::Type.register(:array, Stretchy::Attributes::Type::Array)
      ActiveModel::Type.register(:hash, Stretchy::Attributes::Type::Hash)
      ActiveModel::Type.register(:keyword, Stretchy::Attributes::Type::Keyword)
      ActiveModel::Type.register(:text, Stretchy::Attributes::Type::Text)
    end
  end
end