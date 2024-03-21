module Stretchy
  module Relations
    module QueryMethods
      module Highlight
        extend ActiveSupport::Concern
        # Highlights the specified fields in the search results.
        #
        # @example
        #   Model.where(body: "turkey").highlight(:body)
        #
        # @param [Hash] args The fields to highlight. Each field is a key in the hash,
        #   and the value is another hash specifying the type of highlighting.
        #   For example, `{body: {type: :plain}}` will highlight the 'body' field
        #   with plain type highlighting.
        #
        # @return [Stretchy::Relation] Returns a Stretchy::Relation object, which can be used
        #   for chaining further query methods.
        def highlight(*args)
          spawn.highlight!(*args)
        end

        def highlight!(*args) # :nodoc:
          self.highlight_values += args
          self
        end

        QueryMethods.register!(:highlight)
      end
    end
  end
end
