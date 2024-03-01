# frozen_string_literal: true
require 'zeitwerk'
require 'amazing_print'
require 'rainbow'
require 'elasticsearch/rails'
require 'elasticsearch/persistence'
require 'active_support/concern' 
require 'active_support/core_ext'

require_relative "stretchy/version"
require_relative "stretchy/instrumentation"
# require_relative "stretchy/associations"

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