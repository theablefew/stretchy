# frozen_string_literal: true
require 'zeitwerk'
require 'amazing_print'
require 'rainbow'
require 'jbuilder'
require 'elasticsearch/model'
require 'elasticsearch/persistence'
require 'active_model'
require 'active_support/all'
require 'active_model/type/array'
require 'active_model/type/hash'

ActiveModel::Type.register(:array, ActiveModel::Type::Array)
ActiveModel::Type.register(:hash, ActiveModel::Type::Hash)

require_relative "stretchy/version"
require_relative "rails/instrumentation/railtie" if defined?(Rails)

module Stretchy
  module Errors
    class QueryOptionMissing < StandardError; end
  end

  class Configuration

    attr_accessor :client
    attr_accessor :opensearch

    def initialize
        @client = Elasticsearch::Client.new url: 'http://localhost:9200'
        @opensearch = false
    end

    def client=(client)
        @client = client
        self.opensearch = true if @client.class.name =~ /OpenSearch/
    end

    def opensearch=(bool)
        @opensearch = bool
        OpenSearchCompatibility.opensearch_patch! if bool
    end

    def opensearch?
        @opensearch
    end

  end

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def configuration
        @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end

end



loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir(__dir__)
loader.setup