module Stretchy
    module Scoping
        class ScopeRegistry # :nodoc:
            # extend ActiveSupport::PerThreadRegistry
            thread_mattr_accessor :registry

            VALID_SCOPE_TYPES = [:current_scope, :ignore_default_scope]

            # def initialize
                self.registry = Hash.new { |hash, key| hash[key] = {} }
            # end

            # Obtains the value for a given +scope_name+ and +variable_name+.
            def self.value_for(scope_type, variable_name)
                raise_invalid_scope_type!(scope_type)
                self.registry[scope_type][variable_name]
            end

            # Sets the +value+ for a given +scope_type+ and +variable_name+.
            def self.set_value_for(scope_type, variable_name, value)
                raise_invalid_scope_type!(scope_type)
                self.registry[scope_type][variable_name] = value
            end

            private

            def raise_invalid_scope_type!(scope_type)
                if !VALID_SCOPE_TYPES.include?(scope_type)
                    raise ArgumentError, "Invalid scope type '#{scope_type}' sent to the registry. Scope types must be included in VALID_SCOPE_TYPES"
                end
            end
        end
    end
end