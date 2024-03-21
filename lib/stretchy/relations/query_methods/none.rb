module Stretchy
  module Relations
    module QueryMethods
      module None
        extend ActiveSupport::Concern

        # Returns a chainable relation with zero records.
        def none
          extending(NullRelation)
        end

        def none! # :nodoc:
          extending!(NullRelation)
        end

        QueryMethods.register!(:none)

      end
    end
  end
end
