module Rails
    module Instrumentation
        module Publishers

            module Record 

                extend ActiveSupport::Concern

                included do
                    unless method_defined?(:search_without_instrumentation!)
                        alias_method :search_without_instrumentation!, :search
                        alias_method :search, :search_with_instrumentation!
                    end
                end

                def search_with_instrumentation!(query_or_definition, options={})
                    ActiveSupport::Notifications.instrument "search.stretchy", 
                      name: "Search", 
                      klass: self.base_class.to_s,
                      search: {index: self.index_name, body: query_or_definition }.merge(options) do
                        search_without_instrumentation!(query_or_definition, options)
                    end
                end

            end

        end
    end
end