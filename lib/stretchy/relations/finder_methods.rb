module Stretchy
  module Relations

      module FinderMethods

        METHODS = [:first, :first!, :last, :last!]

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
