require 'virtus'
require 'active_support/hash_with_indifferent_access'

module Stretchy
    module Attributes
        class Hash < Virtus::Attribute
            primitive ::ActiveSupport::HashWithIndifferentAccess

            def coerce(value)
                coerced = ActiveSupport::HashWithIndifferentAccess.new value
                Hashie::Mash.new coerced
            end
        end
    end
end