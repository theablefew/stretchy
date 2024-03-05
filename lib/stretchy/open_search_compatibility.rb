module Stretchy
    module OpenSearchCompatibility
    extend ActiveSupport::Concern

        # Patches the Elasticsearch::Persistence::Repository::Search module to remove the 
        # document type from the request for compatability with OpenSearch
        def self.opensearch_patch!
            patch = Module.new do
                def search(query_or_definition, options={})
                    request = { index: index_name }
            
                    if query_or_definition.respond_to?(:to_hash)
                        request[:body] = query_or_definition.to_hash
                    elsif query_or_definition.is_a?(String)
                        request[:q] = query_or_definition
                    else
                        raise ArgumentError, "[!] Pass the search definition as a Hash-like object or pass the query as a String" +
                            " -- #{query_or_definition.class} given."
                    end
            
                    Elasticsearch::Persistence::Repository::Response::Results.new(self, client.search(request.merge(options)))
                end

                def count(query_or_definition=nil, options={})
                    query_or_definition ||= { query: { match_all: {} } }
                    request = { index: index_name}
          
                    if query_or_definition.respond_to?(:to_hash)
                      request[:body] = query_or_definition.to_hash
                    elsif query_or_definition.is_a?(String)
                      request[:q] = query_or_definition
                    else
                      raise ArgumentError, "[!] Pass the search definition as a Hash-like object or pass the query as a String" +
                          " -- #{query_or_definition.class} given."
                    end
          
                    client.count(request.merge(options))['count']
                end
            end

            store = Module.new do
                def save(document, options={})
                serialized = serialize(document)
                id = __get_id_from_document(serialized)
                request = { index: index_name,
                            id: id,
                            body: serialized }
                client.index(request.merge(options))
              end
      

              def update(document_or_id, options = {})
                if document_or_id.is_a?(String) || document_or_id.is_a?(Integer)
                  id = document_or_id
                  body = options
                else
                  document = serialize(document_or_id)
                  id = __extract_id_from_document(document)
                  if options[:script]
                    body = options
                  else
                    body = { doc: document }.merge(options)
                  end
                end
                client.update(index: index_name, id: id, body: body)
              end
      
              def delete(document_or_id, options = {})
                if document_or_id.is_a?(String) || document_or_id.is_a?(Integer)
                  id = document_or_id
                else
                  serialized = serialize(document_or_id)
                  id = __get_id_from_document(serialized)
                end
                client.delete({ index: index_name, id: id }.merge(options))
              end
            end


            ::Elasticsearch::Persistence::Repository.send(:include, patch)
            ::Elasticsearch::Persistence::Repository.send(:include, store)
        end


    end
end