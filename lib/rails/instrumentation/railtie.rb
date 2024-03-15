module Stretchy
  module Instrumentation

    class Railtie < ::Rails::Railtie

      require 'rails/instrumentation/publishers'
      Stretchy.instrument!

      ActiveSupport::Notifications.subscribe 'search.stretchy' do |name, start, finish, id, payload|
        message = [
           Rainbow("  #{payload[:klass]}").bright, 
           "(#{(finish.to_time - start.to_time).round(2)}ms)",
           Stretchy::Utils.to_curl(payload[:klass].constantize, payload[:search])
        ].join(" ")
        ::Rails.logger.debug(Rainbow(message).color(:yellow))
     end

      # initializer 'stretchy.set_defaults' do
      #   config.elasticsearch_cache_store = :redis_store
      #   config.elasticsearch_expire_cache_in = 15.minutes
      # end

    end
  end
end
