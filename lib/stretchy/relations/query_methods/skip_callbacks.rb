module Stretchy
  module Relations
    module QueryMethods
      module SkipCallbacks
        extend ActiveSupport::Concern
        # Allows you to skip callbacks for the specified fields.
        #
        # This method is used to skip callbacks that are added by `query_must_have` for the specified fields for the current query. It accepts a variable number of arguments, each of which is the name of a field to skip callbacks for.
        #
        # ### Parameters
        #
        # - `args:` The Array of field names to skip callbacks for.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified fields to skip callbacks for.
        #
        # ---
        #
        # ### Examples
        #
        # #### Skip callbacks for a single field
        #
        # ```ruby
        #   Model.skip_callbacks(:routing)
        # ```
        #
        # #### Skip callbacks for multiple fields
        #
        # ```ruby
        #   Model.skip_callbacks(:routing, :relevance)
        # ```
        #
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
