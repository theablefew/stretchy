module Stretchy
    module Common
        extend ActiveSupport::Concern

        def highlights_for(attribute)
            highlights[attribute.to_s]
        end

        class_methods do

            # Set the default sort key to be used in sort operations
            #
            def default_sort_key(field = nil)
                @default_sort_key = field unless field.nil?
                @default_sort_key
            end

            def default_size(size = nil)
                @default_size = size unless size.nil?
                @default_size
            end

            def default_pipeline(pipeline = nil)
                @default_pipeline = pipeline.to_s unless pipeline.nil?
                @default_pipeline
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