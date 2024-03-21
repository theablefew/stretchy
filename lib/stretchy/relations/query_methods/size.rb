module Stretchy
  module Relations
    module QueryMethods
      module Size
        extend ActiveSupport::Concern
        # Sets the maximum number of records to be retrieved.
        #
        # @param args [Integer] the maximum number of records to retrieve
        #
        # @example
        #   Model.size(10)
        #
        # @return [ActiveRecord::Relation] a new relation, which reflects the limit
        # @see #limit
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