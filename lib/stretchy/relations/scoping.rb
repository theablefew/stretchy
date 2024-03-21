module Stretchy
  module Relations
    module Scoping
      extend ActiveSupport::Concern

      included do
        include Default
        include Named
      end

      module ClassMethods
        def base_class
          self
        end

        def current_scope
            ScopeRegistry.new.registry[:current_scope][base_class.to_s]
            # ScopeRegistry.value_for(:current_scope, base_class.to_s)
        end

        def current_scope=(scope) #:nodoc:
          ScopeRegistry.new.registry[:current_scope][base_class.to_s] = scope
          # ScopeRegistry.set_value_for(:current_scope, base_class.to_s, scope)
        end
      end


    end
  end
end
