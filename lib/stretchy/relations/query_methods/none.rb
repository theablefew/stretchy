module Stretchy
  module Relations
    module QueryMethods
      module None
        extend ActiveSupport::Concern

        # Returns a chainable relation with zero records.
        def none
          extending(Stretchy::Relations::NullRelation)
        end

        def none! # :nodoc:
          extending!(Stretchy::Relations::NullRelation)
        end

        QueryMethods.register!(:none)

      end
    end
  end
end
