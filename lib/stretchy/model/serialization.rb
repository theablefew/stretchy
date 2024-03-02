module Stretchy
    module Model 
        module Serialization
            extend ActiveSupport::Concern

            def serialize(document)
                Hash[document.to_hash.map { |k,v|  v.upcase! if k == :title; [k,v] }]
            end

            def deserialize(document)
                attribs = ActiveSupport::HashWithIndifferentAccess.new(document['_source']).deep_symbolize_keys
                _id = __get_id_from_document(document)
                attribs[:id] = _id if _id
                klass.new attribs
            end

        end
    end
end
    