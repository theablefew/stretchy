module Elasticsearch
  module Persistence
    module Model
      module Callbacks

        extend ActiveSupport::Concern


        included do

          instance_variable_set("@_circuit_breaker_callbacks", [])

        end

        class_methods do


          def circuit_breaker_callbacks
            instance_variable_get("@_circuit_breaker_callbacks") || []
          end

          def query_must_have(*args, &block)
            options = args.extract_options!

            cb = block_given? ? block : options[:validate_with]

            options[:message] = "does not exist in #{options[:in]}." unless options.has_key? :message

            instance_variable_get("@_circuit_breaker_callbacks") << {name: args.first, options: options, callback: cb}

          end
        end

      end
    end
  end
end
