module Stretchy
  module Relations
    module QueryMethods
      module Extending
        extend ActiveSupport::Concern
        def extending(*modules, &block)
          if modules.any? || block
            spawn.extending!(*modules, &block)
          else
            self
          end
        end

        def extending!(*modules, &block) # :nodoc:
          modules << Module.new(&block) if block
          modules.flatten!

          self.extending_values += modules
          extend(*extending_values) if extending_values.any?

          self
        end

        QueryMethods.register!(:extending)

      end
    end
  end
end
