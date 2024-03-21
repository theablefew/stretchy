module Stretchy
  module Relations
    module QueryMethods
      module Ids
        def ids(*args)
          spawn.ids!(*args)
        end

        def ids!(*args) # :nodoc:
          self.ids_values += args
          self
        end

        QueryMethods.register!(:ids)
      end
    end
  end
end