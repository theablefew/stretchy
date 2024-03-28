module Stretchy
    module Model
      module Callbacks

        extend ActiveSupport::Concern


        included do
          mattr_accessor :_circuit_breaker_callbacks, default: []

          define_model_callbacks :initialize, only: :after
          define_model_callbacks :create, :save, :update, :destroy
          define_model_callbacks :find, :touch, only: :after
        end

        class_methods do

          def query_must_have(*args, &block)
            options = args.extract_options!

            cb = block_given? ? block : options[:validate_with]

            options[:message] = "does not exist in #{options[:in]}." unless options.has_key? :message

            _circuit_breaker_callbacks << {name: args.first, options: options, callback: cb}

          end
        end

      end
    end
end
