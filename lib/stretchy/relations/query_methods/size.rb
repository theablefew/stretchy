module Stretchy
  module Relations
    module QueryMethods
      module Size
        extend ActiveSupport::Concern
        # Sets the maximum number of records to be retrieved.
        #
        # This method is used to limit the number of records returned by the query. It accepts an integer as an argument.
        #
        # ### Parameters
        #
        # - `args:` The Integer representing the maximum number of records to retrieve.
        #
        # ### Returns
        # Returns a new Stretchy::Relation, which reflects the limit.
        #
        # ---
        #
        # ### Examples
        #
        # #### Limit the number of records
        #
        # ```ruby
        #   Model.size(10)
        # ```
        #
        def size(args)
          spawn.size!(args)
        end

        def size!(args) # :nodoc:
          self.size_value = args
          self
        end

        # Alias for {#size}
        # @see #size
        alias :limit :size

        QueryMethods.register!(:limit, :size)
      end
    end
  end
end