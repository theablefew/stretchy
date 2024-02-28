module Elasticsearch
  module Persistence

    module SearchOptionMethods
      extend ActiveSupport::Concern

      def routing(args)
        check_if_method_has_arguments!(:routing, args)
        spawn.routing!(args)
      end

      def routing!(args)
        merge_search_option_values(:routing, args)
        self
      end

      def search_type(args)
        check_if_method_has_arguments!(:search_type, args)
        spawn.search_type!(args)
      end

      def search_type!(args)
        merge_search_option_values(:search_type, args)
        self
      end

      def search_options(*args)
        spawn.search_options!(*args)
      end

      def search_options!(*args)
        self.search_option_values += args
        self
      end

      private

      def merge_search_option_values(key, value)
        self.search_option_values += [Hash[key,value]]
      end

    end
  end
end
