module Stretchy
  module Relations
    module QueryMethods
      module Order
      extend ActiveSupport::Concern
        # Allows you to add one or more sorts on specified fields.
        #
        # @overload order(attribute: direction, ...)
        #   @param attribute [Symbol] the attribute to sort by
        #   @param direction [Symbol] the direction to sort in (:asc or :desc)
        #
        # @overload order(attribute: {order: direction, mode: mode, ...}, ...)
        #   @param params [Hash] attributes to sort by
        #   @param params [Symbol] :attribute the attribute name as key to sort by
        #   @param options [Hash]  a hash containing possible sorting options 
        #   @option options [Symbol] :order the direction to sort in (:asc or :desc)
        #   @option options [Symbol] :mode the mode to use for sorting (:avg, :min, :max, :sum, :median)
        #   @option options [Symbol] :numeric_type the numeric type to use for sorting (:double, :long, :date, :date_nanos) 
        #   @option options [Symbol] :missing the value to use for documents without the field
        #   @option options [Hash] :nested the nested sorting options
        #   @option nested [String] :path the path to the nested object
        #   @option nested [Hash] :filter the filter to apply to the nested object
        #   @option nested [Hash] :max_children the maximum number of children to consider per root document when picking the sort value. Defaults to unlimited
        #
        # @example
        #   Model.order(created_at: :asc)
        #     # Elasticsearch equivalent
        #     #=> "sort" : [{"created_at" : "asc"}]
        #
        #   Model.order(age: :desc, name: :asc, price: {order: :desc, mode: :avg})
        #
        #     # Elasticsearch equivalent
        #     #=> "sort" : [
        #         { "price" : {"order" : "desc", "mode": "avg"}},
        #         { "name" : "asc" },
        #         { "age" : "desc" }
        #       ]
        #
        # @return [Stretchy::Relation] a new relation with the specified order
        # @see #sort
        def order(*args)
          check_if_method_has_arguments!(:order, args)
          spawn.order!(*args)
        end

        def order!(*args) # :nodoc:
          self.order_values += args.first.zip.map(&:to_h)
          self
        end

        # Alias for {#order}
        # @see #order
        alias :sort :order
        QueryMethods.register!(:sort, :order)

      end
    end
  end
end
