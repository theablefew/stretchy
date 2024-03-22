module Stretchy
  module Relations
    module QueryMethods
      module HasField
        extend ActiveSupport::Concern

        # Checks if a field exists in the Elasticsearch document.
        #
        # This method is used to filter the results of a query based on whether a field exists or not in the document.
        # It accepts a field name as an argument and adds an `exists` filter to the query.
        #
        # ### Parameters
        # - `field:` The Symbol or String representing the field name.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the `exists` filter applied.
        #
        # ---
        #
        # ### Examples
        #
        # #### Has field
        # ```ruby
        #   Model.has_field(:title)
        # ```
        #
        # #### Nested field exists
        # ```ruby
        #   Model.has_field('author.name')
        # ```
        #
        def has_field(field)
          spawn.filter_query(:exists, {field: field})
        end

        QueryMethods.register!(:has_field)
      end
    end
  end
end
