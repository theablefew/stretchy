# This module provides caching functionality for Elasticsearch queries.
module Elasticsearch
  module Persistence
    module QueryCache
      module CacheMethods
        # Accessor for forcing cache
        mattr_accessor :force_cache
        # Accessor for cache store
        mattr_accessor :cache_store
        # Accessor for cache store expiration time
        mattr_accessor :cache_store_expire_in

        # Default cache store expiration time
        @@cache_store_expire_in = 300

        # Default value for forcing cache
        @@force_cache = false

        # This method sets the force_cache flag to true, executes the block, and then sets the flag back to false.
        # This is used to force caching for a specific query.
        #
        # Example:
        #
        #   Elasticsearch::Persistence::QueryCache::CacheMethods.cache do
        #     MyModel.search('foo')
        #   end
        #
        def cache
          Elasticsearch::Persistence.force_cache = true
          lm = yield
          Elasticsearch::Persistence.force_cache = false
          lm
        end

        # This method sets up the cache store based on the cache_store configuration.
        # It returns an instance of the configured cache store.
        #
        # Example:
        #
        #   Elasticsearch::Persistence.cache_store = :redis_store
        #   Elasticsearch::Persistence.cache_store_expire_in = 600
        #   Elasticsearch::Persistence.setup_store!
        #
        def setup_store!
          case Elasticsearch::Persistence.cache_store
          when :redis_store
            ActiveSupport::Cache::RedisStore
          when :memory_store
            ActiveSupport::Cache::MemoryStore
          else
            ActiveSupport::Cache::MemoryStore
          end.new(namespace: "elasticsearch", expires_in: Elasticsearch::Persistence.cache_store_expire_in)
        end
      end

      # This method returns the query cache store.
      #
      # Example:
      #
      #   Elasticsearch::Persistence::QueryCache.store
      #
      def store
        @query_cache ||= Elasticsearch::Persistence.setup_store!
      end

      # This method caches the query result if the cache key exists and force_cache is true.
      # Otherwise, it executes the block and caches the result if force_cache is true.
      # It returns the query result.
      #
      # Example:
      #
      #   Elasticsearch::Persistence::QueryCache.cache_query('foo', MyModel) do
      #     MyModel.search('foo')
      #   end
      #
      def cache_query(query, klass)
        cache_key = sha(query)
        Elasticsearch::Persistence.force_cache
        result = if store.exist?(cache_key) && Elasticsearch::Persistence.force_cache
            ActiveSupport::Notifications.instrument "cache.query.elasticsearch",
              name: klass.name,
              query: query

            store.fetch cache_key
          else
            res = []
            ActiveSupport::Notifications.instrument "query.elasticsearch",
              name: klass.name,
              query: query do
              res = yield
            end

            store.write(cache_key, res) if Elasticsearch::Persistence.force_cache
            res
          end
        result.dup
      end

      private

      # This method returns the SHA256 hash of the input string.
      #
      # Example:
      #
      #   Elasticsearch::Persistence::QueryCache.sha('foo')
      #
      def sha(str)
        Digest::SHA256.new.hexdigest(str)
      end
    end
  end
end
