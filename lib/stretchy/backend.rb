module Stretchy
  # The search engine behind the configured client, and everything that differs between engines.
  #
  # Chosen from the client class, so configuring an `OpenSearch::Client` selects
  # Stretchy::Backend::OpenSearch and anything else selects Stretchy::Backend::Elasticsearch.
  #
  # ```ruby
  #   Stretchy.configuration.backend.not_found_error # => OpenSearch::Transport::Transport::Errors::NotFound
  # ```
  class Backend
    def self.for(client)
      client.class.name.to_s.match?(/OpenSearch/) ? Backend::OpenSearch.new : Backend::Elasticsearch.new
    end

    # The client library's top-level module, e.g. `::OpenSearch`.
    def namespace
      raise NotImplementedError
    end

    def opensearch?
      false
    end

    def not_found_error
      transport_errors::NotFound
    end

    def server_error
      transport_errors::InternalServerError
    end

    def ==(other)
      other.class == self.class
    end

    private

    def transport_errors
      namespace::Transport::Transport::Errors
    end
  end
end
