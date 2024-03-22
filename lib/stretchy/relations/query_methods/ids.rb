module Stretchy
  module Relations
    module QueryMethods
      module Ids

        # Filters documents that only have the provided ids.
        #
        # This method is used to filter the results of a query based on document ids. It accepts an array of ids.
        #
        # ### Parameters
        #
        # - `args:` The Array of ids to be matched by the query.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified ids to be matched.
        #
        # ---
        #
        # ### Examples
        #
        # #### Filter by ids
        #
        # ```ruby
        #   Model.ids([1, 2, 3])
        # ```
        #
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