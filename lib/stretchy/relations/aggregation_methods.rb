module Stretchy
    module Relations
        module AggregationMethods 

            @_registry = []

            class << self
              # Define the register! method
              def register!(*methods)
                @_registry += methods
              end
          
              # Define a method to access the registry
              def registry
                @_registry.flatten.compact.uniq
              end
            end

            # Load all the aggregation methods
            Dir["#{File.dirname(__FILE__)}/aggregation_methods/*.rb"].each do |file|
              basename = File.basename(file, '.rb')
              module_name = basename.split('_').collect(&:capitalize).join
              mod = const_get(module_name)
              include mod
            end

        end
    end
end