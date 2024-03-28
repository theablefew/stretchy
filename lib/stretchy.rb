# frozen_string_literal: true
require 'zeitwerk'
require 'amazing_print'
require 'rainbow'
require 'jbuilder'
require 'elasticsearch/model'
require 'elasticsearch/persistence'
require 'active_model'
require 'active_support/all'

require_relative "stretchy/version"
require_relative "stretchy/rails/instrumentation/railtie" if defined?(Rails)
require_relative "stretchy/rails/railtie" if defined?(Rails)
require_relative 'elasticsearch/api/namespace/machine_learning/model'

module Stretchy

  def self.loader
    @loader ||= begin
      loader = Zeitwerk::Loader.new
      loader.tag = File.basename(__FILE__, ".rb")
      loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
      loader.push_dir(__dir__)
      loader.inflector.inflect("ip" => "IP")
      loader
    end
  end

  def self.boot!
    loader.setup
    Elasticsearch::API.send(:include, Elasticsearch::API::MachineLearning::Models)
    Stretchy::Attributes.register!
  end

  def self.instrument!
    Stretchy::Delegation::GatewayDelegation.send(:include, Rails::Instrumentation::Publishers::Record)
  end

  module Errors
    class QueryOptionMissing < StandardError; end
  end

  class Configuration

    attr_accessor :options

    delegate_missing_to :@options

    def initialize
        @options = Hashie::Mash.new(
          default_keyword_field: :keyword,
          add_keyword_field_to_text_attributes: true,
          auto_target_keywords: true,
          opensearch: false,
          client: Elasticsearch::Client.new(url: 'http://localhost:9200')
        )
    end

    def client=(klient)
        @options[:client] = klient
        self.opensearch = true if klient.class.name =~ /OpenSearch/
    end

    def search_backend_const
        self.opensearch? ? OpenSearch : Elasticsearch
    end

    def opensearch=(bool)
        @options[:opensearch] = bool
        OpenSearchCompatibility.opensearch_patch! if bool
    end

    def opensearch?
        @options[:opensearch]
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

Stretchy.loader.enable_reloading if defined?(Rails) && Rails.env.development? || ENV['RACK_ENV'] == 'development'
Stretchy.boot!

