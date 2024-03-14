module Stretchy
  module Relations

      module FinderMethods

        def first
          return results.first if @loaded
          spawn.first!.results.first
        end

        def first!
          spawned = spawn
          if spawned.order_values.length.zero? 
            spawn.sort(Hash[default_sort_key, :asc]).spawn.size(1)
          elsif spawned.order_values.length >= 1
            first_order_value = spawned.order_values.shift
            new_direction = Hash[first_order_value.keys.first, :asc] 
            spawned.order_values.unshift(new_direction)
            spawned.size(1)
          end
          self
        end

        def last
          return results.last if @loaded
          spawn.last!.results.first
        end

        def last!
          spawned = spawn
          if spawned.order_values.length.zero?
            spawn.sort(Hash[default_sort_key, :desc]).spawn.size(1)
          elsif spawned.order_values.length >= 1
            first_order_value = spawned.order_values.shift
            new_direction = Hash[first_order_value.keys.first, :desc] 
            spawned.order_values.unshift(new_direction)
            spawned.size(1)
          end
          self
        end

        # size is not permitted to the count API but queries are.
        #
        # if a query is supplied with `.count` then the user wants a count of the results
        # matching the query
        #  
        # however, the default_size is used to limit the number of results returned
        # so we remove the size from the query and then call `.count` API
        #
        # but if the user supplies a limit, then we should assume they want a count of the results
        # which could lead to some confusion 
        # suppose the user calls `.size(100).count` and the default_size is 100
        # if we remove size from the query, then the count could be greater than 100
        # 
        # I think the best way to handle this is to remove the size from the query only if it was  
        # applied by the default_size
        # If the user supplies a limit, then we should assume they want a count of the results
        # 
        # if size is called with a limit,
        def count
          return results.count if @loaded || @values[:size].present?
          spawn.count!
        end

        def count!
          @values[:count] = true
          spawned = spawn
          spawned.order_values.clear
          spawned.results
        end

      end
    end
end
