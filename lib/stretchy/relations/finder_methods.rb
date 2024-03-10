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
          elsif spawned.order_values.length == 1
            new_direction = Hash[spawned.order_values.first.keys.first, :asc] 
            spawned.order_values = [] 
            spawned.order(**new_direction).size(1)
          elsif
            spawn.size(1)
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
          elsif spawned.order_values.length == 1
              new_direction = Hash[spawned.order_values.first.keys.first, :desc]
              spawned.order_values.clear 
              spawned.order(new_direction).size(1)
          else
            spawn.size(1)
          end
          self
        end

        def count
          return results.count if @loaded
          spawn.count!
        end

        def count!
          @values[:count] = true
          @values.delete(:size)
          spawn.results
        end

      end
    end
end
