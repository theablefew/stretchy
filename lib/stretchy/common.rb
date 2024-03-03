module Stretchy
    module Common
        extend ActiveSupport::Concern

        def inspect
            "#<#{self.class.name} #{attributes.map { |k,v| "#{k}: #{v.blank? ? 'nil' : v}" }.join(', ')}>"
        end


        class_methods do

            # Set the default sort key to be used in sort operations
            #
            def default_sort_key(field = nil)
                @default_sort_key = field unless field.nil?
                @default_sort_key
            end

            def default_size(size = 10000)
                @default_size = size
            end

            private

            # Return a Relation instance to chain queries
            #
            def relation
                Relation.create(self, {})
            end

        end
    end
end