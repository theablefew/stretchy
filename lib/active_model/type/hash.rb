module ActiveModel
    module Type
        class Hash < Value # :nodoc:
            def type
                :hash
            end

            private

            def cast_value(value)
                Elasticsearch::Model::HashWrapper[value]
            end
        end
    end
end
