module Stretchy
  module Relations
    module QueryMethods
      module Field
        extend ActiveSupport::Concern
        
        # Public: Specify the fields to be returned by the Elasticsearch query.
        #
        # This method accepts a variable number of arguments, each of which is the name of a field to be returned.
        # If no arguments are provided, all fields are returned.
        #
        # To retrieve specific fields in the search response, use the fields parameter. 
        # Because it consults the index mappings, the fields parameter provides several advantages over referencing 
        # the `_source` directly. Specifically, the fields parameter:
        #   Returns each value in a standardized way that matches its mapping type
        #   Accepts multi-fields and field aliases
        #   Formats dates and spatial data types
        #   Retrieves runtime field values
        #   Returns fields calculated by a script at index time
        #   Returns fields from related indices using lookup runtime fields
        #
        # args - The Array of field names to be returned by the query (default: []).
        #
        # Examples
        #
        #   Model.fields(:title, :author)
        #   Model.field('author.name', 'author.age')
        #   Model.fields('books.*')
        #
        # Returns a new relation with the specified fields to be returned.
        def field(*args)
          spawn.field!(*args)
        end
        alias :fields :field

        def field!(*args) # :nodoc:
          self.field_values += args
          self
        end

        QueryMethods.register!(:field, :fields)

      end
    end
  end
end
