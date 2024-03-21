module Stretchy
  module Relations
    module QueryMethods
      module Bind
        extend ActiveSupport::Concern
        def bind(value)
          spawn.bind!(value)
        end

        def bind!(value) # :nodoc:
          self.bind_values += [value]
          self
        end

        QueryMethods.register!(:bind)
      end
    end
  end
end