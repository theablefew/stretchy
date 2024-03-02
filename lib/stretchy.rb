# frozen_string_literal: true
require 'zeitwerk'
require 'amazing_print'
require 'rainbow'
require 'jbuilder'
# require 'elasticsearch/rails'
require 'elasticsearch/model'
require 'elasticsearch/persistence'
# require 'active_support/concern' 
require 'active_model'
require 'active_support/all'
require 'active_model/type/array'
require 'active_model/type/hash'

ActiveModel::Type.register(:array, ActiveModel::Type::Array)
ActiveModel::Type.register(:hash, ActiveModel::Type::Hash)

require_relative "stretchy/version"
require_relative "stretchy/instrumentation/railtie" if defined?(Rails)

module Stretchy

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end

end

loader = Zeitwerk::Loader.new
loader.tag = File.basename(__FILE__, ".rb")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.push_dir(__dir__)
loader.setup