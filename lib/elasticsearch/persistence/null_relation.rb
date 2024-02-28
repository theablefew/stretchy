# frozen_string_literal: true

module Elasticsearch
  module Persistence
    module NullRelation # :nodoc:
      def pluck(*column_names)
        []
      end

      def delete_all
        0
      end

      def update_all(_updates)
        0
      end

      def delete(_id_or_array)
        0
      end

      def empty?
        true
      end

      def none?
        true
      end

      def any?
        false
      end

      def one?
        false
      end

      def many?
        false
      end

      def exists?(_conditions = :none)
        false
      end

      def or(other)
        other.spawn
      end


        def exec_queries
          @records = OpenStruct.new(klass: Elasticsearch::Persistence::Repository::Class, total: 0, results: []).freeze
        end
    end
  end
end
