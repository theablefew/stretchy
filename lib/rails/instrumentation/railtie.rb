module Stretchy
  module Instrumentation

    class Railtie < ::Rails::Railtie
      include ActionView::Helpers::NumberHelper
      def time_diff(start, finish)
        begin
          ((finish.to_time - start.to_time) * 1000).to_s(:rounded, precision: 5, strip_insignificant_zeros: true)
        rescue
          number_with_precision((finish.to_time - start.to_time) * 1000, precision: 5, strip_insignificant_zeros: true)
        end
      end

      ActiveSupport::Notifications.subscribe 'query.elasticsearch' do |name, start, finish, id, payload|
        ::Rails.logger.debug(["  #{payload[:name]}".bright, "(#{time_diff(start,finish)}ms)",payload[:query]].join(" ").color(:yellow))
      end

      ActiveSupport::Notifications.subscribe 'cache.query.elasticsearch' do |name, start, finish, id, payload|
        ::Rails.logger.debug(["  #{payload[:name]}".bright, "CACHE".color(:mediumpurple).bright ,"(#{time_diff(start,finish)}ms)", payload[:query]].join(" ").color(:yellow))
      end

      initializer 'stretchy.set_defaults' do
        config.elasticsearch_cache_store = :redis_store
        config.elasticsearch_expire_cache_in = 15.minutes
      end

    end
  end
end
