module Stretchy
  module MachineLearning
    # Values declared on an ML resource. Nested blocks build nested settings with any keys.
    #
    # ```ruby
    #   settings = Stretchy::MachineLearning::Settings.new
    #   settings.headers { content_type "application/json" }
    #   settings[:headers].content_type # => "application/json"
    # ```
    class Settings
      def initialize
        @values = {}
      end

      def [](key)
        value = @values[key.to_sym]
        value.is_a?(::Hash) ? Stretchy::HashWrapper[value] : value
      end

      def []=(key, value)
        @values[key.to_sym] = value
      end

      def key?(key)
        @values.key?(key.to_sym)
      end

      def as_json(*)
        @values.as_json
      end

      def method_missing(method, *args, &block)
        if block
          self[method] = self.class.new.tap { |nested| nested.instance_eval(&block) }
        elsif args.empty?
          self[method]
        elsif args.one?
          self[method] = args.first
        else
          super
        end
      end

      def respond_to_missing?(method, include_private = false)
        key?(method) || super
      end
    end
  end
end
