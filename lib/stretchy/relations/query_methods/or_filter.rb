module Stretchy
  module Relations
    module QueryMethods
      module OrFilter
        extend ActiveSupport::Concern
        # @deprecated in elasticsearch 7.x+ use {#filter_query} instead
        def or_filter(name, options = {}, &block)
          spawn.or_filter!(name, options, &block)
        end

        def or_filter!(name, options = {}, &block) # :nodoc:
          self.or_filter_values += [{name: name, args: options}]
          self
        end

        QueryMethods.register!(:or_filter)

      end
    end
  end
end
