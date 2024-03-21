module Stretchy
  module Relations
    module QueryMethods
      module Source
        extend ActiveSupport::Concern
        # Controls which fields of the source are returned.
        #
        # This method supports source filtering, which allows you to include or exclude fields from the source. 
        # You can specify fields directly, use wildcard patterns, or use an object containing arrays 
        # of includes and excludes patterns.
        #
        # If the includes property is specified, only source fields that match one of its patterns are returned. 
        # You can exclude fields from this subset using the excludes property.
        #
        # If the includes property is not specified, the entire document source is returned, excluding any 
        # fields that match a pattern in the excludes property.
        #
        # @overload source(opts)
        #   @param opts [Hash, Boolean] a hash containing :includes and/or :excludes arrays, or a boolean indicating whether 
        #                               to include the source
        #
        # @example
        #   Model.source(includes: [:name, :email])
        #   Model.source(excludes: [:name, :email])
        #   Model.source(false) # don't include source
        #
        # @return [Stretchy::Relation] a new relation, which reflects the source filtering
        def source(*args)
          spawn.source!(*args)
        end

        def source!(*args) # :nodoc:
          self.source_values += args
          self
        end

        QueryMethods.register!(:source)
      end
    end
  end
end
