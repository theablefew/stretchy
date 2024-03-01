module Stretchy
  module IndexHelpers
    extend ActiveSupport::Concern

    included do
      index_name [ENV['HEROKU_APP_NAME']&.underscore, self.name.tableize].compact.join("_")
    end

    class_methods do
      def time_based_indices(range)
        ((range.begin.to_datetime..range.end.to_datetime).to_a.map(&:utc) << range.end.to_datetime.utc).map { |d| "#{self.index_name.gsub(/\*/, "")}#{d.strftime("%Y_%m*")}" }.uniq.join(",")
      end
    end
  end
end
