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
            end
            ::Elasticsearch::Persistence::Repository.send(:include, patch)
        end
    end
end