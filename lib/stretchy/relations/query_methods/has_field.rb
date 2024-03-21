module Stretchy
  module Relations
    module QueryMethods
      module HasField
        extend ActiveSupport::Concern
        # Checks if a field exists in the documents.
        #
        # This is a helper for the exists filter in Elasticsearch, which returns documents 
        # that have at least one non-null value in the specified field.
        #
        # @param field [Symbol, String] the field to check for existence
        #
        # @example
        #   Model.has_field(:name)
        #
        # @return [ActiveRecord::Relation] a new relation, which reflects the exists filter
        def has_field(field)
          spawn.filter_query(:exists, {field: field})
        end

        QueryMethods.register!(:has_field)
      end
    end
  end
end
