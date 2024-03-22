module Stretchy
  # used to define and manage the attributes of a model in Stretchy. It provides methods for getting and setting attribute values, inspecting the model, and registering attribute types.
  #
  # ### Methods
  #
  # - `[](attribute)`: Retrieves the value of the specified attribute.
  # - `[]=(attribute, value)`: Sets the value of the specified attribute.
  # - `inspect`: Returns a string representation of the model, including its class name and attributes.
  # - `self.inspect`: Returns a string representation of the model class, including its name and attribute types.
  # - `attribute_mappings`: Returns a JSON representation of the attribute mappings for the model.
  # - `self.register!`: Registers the attribute types with ActiveModel.
  #
  # ### Example
  #
  # In this example, the `Attributes` module is used to define an attribute for `MyModel`, get and set the attribute value, inspect the model and the model class, and get the attribute mappings.
  #
  # ```ruby
  # class MyModel < Stretchy::Record
  #   attribute :title, :string
  # end
  #
  # model = MyModel.new(title: "hello")
  # model[:title] # => "hello"
  # model.inspect # => "#<MyModel title: hello>"
  # MyModel.inspect # => "#<MyModel title: string>"
  # MyModel.attribute_mappings # => {properties: {title: {type: "string"}}}
  # ```
  #
  #
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

      def attribute_mappings
        {properties: attribute_types.map { |k,v| v.mappings(k) }.reduce({}, :merge)}.as_json
      end
    end

    def self.register!
      ActiveModel::Type.register(:array, Stretchy::Attributes::Type::Array)
      ActiveModel::Type.register(:binary, Stretchy::Attributes::Type::Binary)
      ActiveModel::Type.register(:boolean, Stretchy::Attributes::Type::Boolean)
      ActiveModel::Type.register(:constant_keyword, Stretchy::Attributes::Type::ConstantKeyword)
      ActiveModel::Type.register(:datetime, Stretchy::Attributes::Type::DateTime)
      ActiveModel::Type.register(:flattened, Stretchy::Attributes::Type::Flattened)
      ActiveModel::Type.register(:geo_point, Stretchy::Attributes::Type::GeoPoint)
      ActiveModel::Type.register(:geo_shape, Stretchy::Attributes::Type::GeoShape)
      ActiveModel::Type.register(:histogram, Stretchy::Attributes::Type::Histogram)
      ActiveModel::Type.register(:hash, Stretchy::Attributes::Type::Hash)
      ActiveModel::Type.register(:ip, Stretchy::Attributes::Type::IP)
      ActiveModel::Type.register(:join, Stretchy::Attributes::Type::Join)
      ActiveModel::Type.register(:keyword, Stretchy::Attributes::Type::Keyword)
      ActiveModel::Type.register(:match_only_text, Stretchy::Attributes::Type::MatchOnlyText)
      ActiveModel::Type.register(:nested, Stretchy::Attributes::Type::Nested)
      ActiveModel::Type.register(:percolator, Stretchy::Attributes::Type::Percolator)
      ActiveModel::Type.register(:point, Stretchy::Attributes::Type::Point)
      ActiveModel::Type.register(:rank_feature, Stretchy::Attributes::Type::RankFeature)
      ActiveModel::Type.register(:rank_features, Stretchy::Attributes::Type::RankFeatures)

      ActiveModel::Type.register(:text, Stretchy::Attributes::Type::Text)
      ActiveModel::Type.register(:token_count, Stretchy::Attributes::Type::TokenCount)
      ActiveModel::Type.register(:dense_vector, Stretchy::Attributes::Type::DenseVector)

      ActiveModel::Type.register(:search_as_you_type, Stretchy::Attributes::Type::SearchAsYouType)
      ActiveModel::Type.register(:sparse_vector, Stretchy::Attributes::Type::SparseVector)
      ActiveModel::Type.register(:string, Stretchy::Attributes::Type::String)
      ActiveModel::Type.register(:version, Stretchy::Attributes::Type::Version)
      ActiveModel::Type.register(:wildcard, Stretchy::Attributes::Type::Wildcard)
      # Numerics
      ActiveModel::Type.register(:long, Stretchy::Attributes::Type::Numeric::Long)
      ActiveModel::Type.register(:integer, Stretchy::Attributes::Type::Numeric::Integer)
      ActiveModel::Type.register(:short, Stretchy::Attributes::Type::Numeric::Short)
      ActiveModel::Type.register(:byte, Stretchy::Attributes::Type::Numeric::Byte)
      ActiveModel::Type.register(:double, Stretchy::Attributes::Type::Numeric::Double)
      ActiveModel::Type.register(:float, Stretchy::Attributes::Type::Numeric::Float)
      ActiveModel::Type.register(:half_float, Stretchy::Attributes::Type::Numeric::HalfFloat)
      ActiveModel::Type.register(:scaled_float, Stretchy::Attributes::Type::Numeric::ScaledFloat)
      ActiveModel::Type.register(:unsigned_long, Stretchy::Attributes::Type::Numeric::UnsignedLong)
      # Ranges
      ActiveModel::Type.register(:integer_range, Stretchy::Attributes::Type::Range::IntegerRange)
      ActiveModel::Type.register(:float_range, Stretchy::Attributes::Type::Range::FloatRange)
      ActiveModel::Type.register(:long_range, Stretchy::Attributes::Type::Range::LongRange)
      ActiveModel::Type.register(:double_range, Stretchy::Attributes::Type::Range::DoubleRange)
      ActiveModel::Type.register(:date_range, Stretchy::Attributes::Type::Range::DateRange)
      ActiveModel::Type.register(:ip_range, Stretchy::Attributes::Type::Range::IpRange)

    end
  end
end