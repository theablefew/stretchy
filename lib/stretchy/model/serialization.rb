module Stretchy
    module Model 
        module Serialization
            extend ActiveSupport::Concern

            def serialize(document)
                document.to_hash
            end

            def deserialize(document)
                attribs = ActiveSupport::HashWithIndifferentAccess.new(document['_source']).deep_symbolize_keys
                attribs[:_highlights] = document["highlight"] if document["highlight"]
                _id = __get_id_from_document(document)
                attribs[:id] = _id if _id
                klass.new attribs
            end

        end
    end
end
