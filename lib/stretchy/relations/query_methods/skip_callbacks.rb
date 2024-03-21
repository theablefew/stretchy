module Stretchy
  module Relations
    module QueryMethods
      module SkipCallbacks
        extend ActiveSupport::Concern
        # Allows you to skip callbacks for the specified fields that are added by query_must_have for 
        # the current query.
        #
        # @example
        #  Model.skip_callbacks(:routing)
        def skip_callbacks(*args)
          spawn.skip_callbacks!(*args)
        end

        def skip_callbacks!(*args) # :nodoc:
          self.skip_callbacks_values += args
          self
        end

        QueryMethods.register!(:skip_callbacks)

      end
    end
  end
end
