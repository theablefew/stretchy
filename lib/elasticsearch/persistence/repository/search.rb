module Elasticsearch
  module Persistence
    module Repository

      # Returns a collection of domain objects by an Elasticsearch query
      #
      module Search
        include Elasticsearch::Persistence::QueryCache
        # Returns a collection of domain objects by an Elasticsearch query
        #
        # Pass the query either as a string or a Hash-like object
        #
        # @example Return objects matching a simple query
        #
        #     repository.search('fox or dog')
        #
        # @example Return objects matching a query in the Elasticsearch DSL
        #
        #    repository.search(query: { match: { title: 'fox dog' } })
        #
        # @example Define additional search parameters, such as highlighted excerpts
        #
        #    results = repository.search(query: { match: { title: 'fox dog' } }, highlight: { fields: { title: {} } })
        #     results.map_with_hit { |d,h| h.highlight.title.join }
        #     # => ["quick brown <em>fox</em>", "fast white <em>dog</em>"]
        #
        # @example Perform aggregations as part of the request
        #
        #     results = repository.search query: { match: { title: 'fox dog' } },
        #                                 aggregations: { titles: { terms: { field: 'title' } } }
        #     results.response.aggregations.titles.buckets.map { |term| "#{term['key']}: #{term['doc_count']}" }
        #     # => ["brown: 1", "dog: 1", ... ]
        #
        # @example Pass additional options to the search request, such as `size`
        #
        #     repository.search query: { match: { title: 'fox dog' } }, size: 25
        #     # GET http://localhost:9200/notes/note/_search
        #     # > {"query":{"match":{"title":"fox dog"}},"size":25}
        #
        # @return [Elasticsearch::Persistence::Repository::Response::Results]
        #
        def search(query_or_definition, options = {})
          request = { index: index_name, body: query_or_definition.to_hash }

          case
          when query_or_definition.respond_to?(:to_hash)
            request.merge!(body: query_or_definition.to_hash)
          when query_or_definition.is_a?(String)
            request.merge!(q: query_or_definition)
          else
            raise ArgumentError, "[!] Pass the search definition as a Hash-like object or pass the query as a String" +
                                 " -- #{query_or_definition.class} given."
          end

          response = cache_query(to_curl(request.merge(options)), klass) { client.search(request.merge(options)) }

          Response::Results.new(self, response)
        end

        # Return the number of domain object in the index
        #
        # @example Return the number of all domain objects
        #
        #     repository.count
        #     # => 2
        #
        # @example Return the count of domain object matching a simple query
        #
        #     repository.count('fox or dog')
        #     # => 1
        #
        # @example Return the count of domain object matching a query in the Elasticsearch DSL
        #
        #    repository.search(query: { match: { title: 'fox dog' } })
        #    # => 1
        #
        # @return [Integer]
        #
        def count(query_or_definition = nil, options = {})
          query_or_definition ||= { query: { match_all: {} } }

          request = { index: index_name, body: query_or_definition.to_hash }
          response = cache_query(to_curl(request.merge(options), "_count"), klass) { client.count(request.merge(options)) }

          response
        end

        private

        ## TODO: Not happy with where this is living right now.
        #
        def to_curl(arguments = {}, end_point = "_search")
          transport = client.transport&.transport
          host = transport.hosts&.first || transport.options[:url]
          arguments[:index] = "_all" if !arguments[:index] && arguments[:type]

          valid_params = [
            :analyzer,
            :analyze_wildcard,
            :default_operator,
            :df,
            :explain,
            :fields,
            :from,
            :ignore_indices,
            :ignore_unavailable,
            :allow_no_indices,
            :expand_wildcards,
            :lenient,
            :lowercase_expanded_terms,
            :preference,
            :q,
            :routing,
            :scroll,
            :search_type,
            :size,
            :sort,
            :source,
            :_source,
            :_source_include,
            :_source_exclude,
            :stats,
            :suggest_field,
            :suggest_mode,
            :suggest_size,
            :suggest_text,
            :timeout,
            :version,
          ]

          method = "GET"
          path = Elasticsearch::API::Utils.__pathify(Elasticsearch::API::Utils.__listify(arguments[:index]), end_point)

          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
          body = arguments[:body]

          params[:fields] = Elasticsearch::API::Utils.__listify(params[:fields]) if params[:fields]

          url = path

          unless host.is_a? String
            host_parts = "#{host[:protocol].to_s}://#{host[:host]}"
            host_parts = "#{host_parts}:#{host[:port]}" if host[:port]
          else
            host_parts = host
          end

          trace_url = "#{host_parts}/#{url}"
          trace_url += "?#{::Faraday::Utils::ParamsHash[params].to_query}" unless params.blank?
          trace_body = body ? " -d '#{body.to_json}'" : ""

          Rainbow("curl -X #{method.to_s.upcase} '#{CGI.unescape(trace_url)}'#{trace_body}\n").color :white
        end
      end
    end
  end
end
