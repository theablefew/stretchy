module Stretchy
  # Reads and writes documents for a single index through the configured client.
  #
  # Each Stretchy::Record class builds one repository (its `gateway`) from its index name,
  # attribute mappings and index settings. The repository works with any client that
  # implements the Elasticsearch/OpenSearch document and indices APIs.
  #
  # ### Example
  #
  # ```ruby
  #   repository = Stretchy::Repository.new(client: OpenSearch::Client.new, index_name: "posts", klass: Post)
  #   repository.save(id: "1", title: "Hello")
  #   repository.find("1") # => #<Post id: 1, title: Hello>
  # ```
  class Repository
    include Stretchy::Model::Serialization

    ID_KEYS = [:id, 'id', :_id, '_id'].freeze

    attr_reader :client, :index_name, :klass, :mappings, :settings

    alias_method :mapping, :mappings

    def initialize(client:, index_name:, klass: nil, mappings: {}, settings: {})
      @client = client
      @index_name = index_name
      @klass = klass
      @mappings = mappings
      @settings = settings
    end

    def save(document, options = {})
      serialized = serialize(document)
      client.index({ index: index_name, id: document_id(serialized), body: serialized }.merge(options))
    end

    def update(document_or_id, options = {})
      if document_or_id.is_a?(String) || document_or_id.is_a?(Integer)
        id = document_or_id
        body = options
      else
        document = serialize(document_or_id)
        id = extract_document_id(document)
        body = options[:script] ? options : { doc: document }.merge(options)
      end
      client.update(index: index_name, id: id, body: body)
    end

    def delete(document_or_id, options = {})
      id = if document_or_id.is_a?(String) || document_or_id.is_a?(Integer)
        document_or_id
      else
        document_id(serialize(document_or_id))
      end
      client.delete({ index: index_name, id: id }.merge(options))
    end

    # Finds one document by id, or many when given several ids or an Array.
    #
    # Raises Stretchy::Errors::RecordNotFound when a single id is missing. Missing
    # documents are returned as nil when finding many.
    def find(*args)
      options = args.last.is_a?(::Hash) ? args.pop : {}
      ids = args.flatten

      if args.one? && !args.first.is_a?(::Array)
        find_one(ids.first, options)
      else
        find_many(ids, options)
      end
    end

    def exists?(id, options = {})
      client.exists({ index: index_name, id: id }.merge(options))
    end

    def search(query_or_definition, options = {})
      request = { index: index_name }.merge(query_request(query_or_definition))
      Results.new(self, client.search(request.merge(options)))
    end

    def count(query_or_definition = nil, options = {})
      query_or_definition ||= { query: { match_all: {} } }
      request = { index: index_name }.merge(query_request(query_or_definition))
      client.count(request.merge(options))['count']
    end

    def create_index!(options = {})
      options = options.dup
      target_index = options.delete(:index) || index_name
      index_settings = options.delete(:settings) || settings.to_hash
      index_mappings = options.delete(:mappings) || mappings.to_hash

      delete_index!(index: target_index, force: true) if options.delete(:force)
      return if index_exists?(index: target_index)

      client.indices.create({ index: target_index, body: { settings: index_settings, mappings: index_mappings } }.merge(options))
    end

    def delete_index!(options = {})
      ignoring_missing_index(options) { |target_index| client.indices.delete(index: target_index) }
    end

    def refresh_index!(options = {})
      ignoring_missing_index(options) { |target_index| client.indices.refresh(index: target_index) }
    end

    def index_exists?(options = {})
      client.indices.exists(index: options[:index] || index_name)
    end

    def inspect
      "#<#{self.class} index_name=#{index_name} klass=#{klass}>"
    end

    private

    def find_one(id, options)
      deserialize(client.get({ index: index_name, id: id }.merge(options)))
    rescue not_found_error => e
      raise Stretchy::Errors::RecordNotFound, e.message
    end

    def find_many(ids, options)
      client.mget({ index: index_name, body: { ids: ids } }.merge(options))['docs'].map do |document|
        deserialize(document) if document['found']
      end
    end

    def query_request(query_or_definition)
      if query_or_definition.respond_to?(:to_hash)
        { body: query_or_definition.to_hash }
      elsif query_or_definition.is_a?(String)
        { q: query_or_definition }
      else
        raise ArgumentError, "Pass the search definition as a Hash-like object or the query as a String -- #{query_or_definition.class} given."
      end
    end

    def ignoring_missing_index(options)
      options = options.dup
      yield(options.delete(:index) || index_name)
    rescue not_found_error
      raise unless options[:force]
    end

    def not_found_error
      Stretchy.configuration.search_backend_const::Transport::Transport::Errors::NotFound
    end

    def document_id(document)
      document[ID_KEYS.find { |key| document[key] }]
    end

    def extract_document_id(document)
      ID_KEYS.inject(nil) { |deleted, key| document[key] ? document.delete(key) : deleted }
    end
  end
end
