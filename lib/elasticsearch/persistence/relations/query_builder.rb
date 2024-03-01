module Elasticsearch
  module Persistence
    module Relations
      class QueryBuilder

        attr_reader :structure, :values

        def initialize(values)
          @structure = Jbuilder.new ignore_nil: true
          @values = values
        end

        def aggregations
          values[:aggregation]
        end

        def filters
          values[:filter]
        end

        def or_filters
          values[:or_filter]
        end

        def query
          @query ||= compact_where(values[:where])
        end

        def query_strings
          @query_string ||= compact_where(values[:query_string], bool: false)
        end

        def must_nots
          @must_nots ||= compact_where(values[:must_not])
        end

        def shoulds
          @shoulds ||= compact_where(values[:should])
        end

        def fields
          values[:field]
        end

        def source
          values[:source]
        end

        def highlights
          values[:highlight]
        end

        def size
          values[:size]
        end

        def sort
          values[:order]
        end

        def query_filters
          values[:filter]
        end

        def search_options
          build_search_options
        end

        def query_string_options
          @query_string_options || {}
        end

        def count?
          values[:count]
        end

        def to_elastic
          @structure = Jbuilder.new ignore_nil: true
          build_query
          build_sort unless sort.blank?
          build_highlights unless highlights.blank?
          build_fields unless fields.blank?
          build_source unless source.blank?
          build_aggregations unless aggregations.blank?
          structure.attributes!.with_indifferent_access
        end

        private

        def missing_bool_query?
          query.nil? && must_nots.nil? && shoulds.nil?
        end

        def missing_query_string?
          query_strings.nil?
        end

        def missing_query_filter?
          query_filters.nil? && or_filters.nil?
        end

        def build_query
          return if missing_bool_query? && missing_query_string? && missing_query_filter?
          structure.query do
            structure.bool do
                  structure.must query unless missing_bool_query?
                  structure.must_not must_nots unless must_nots.nil?
                  structure.set! :should, shoulds unless shoulds.nil?

              build_filtered_query if query_filters || or_filters

            end unless missing_bool_query? && missing_query_filter?


            structure.query_string do
              structure.extract! query_string_options, *query_string_options.keys
              structure.query query_strings
            end unless query_strings.nil?
          end.with_indifferent_access
        end

        def build_filtered_query
          structure.filter do
            structure.or do
              or_filters.each do |f|
                structure.child! do
                  structure.set! f[:name], extract_filters(f[:name], f[:args])
                end
              end
            end unless or_filters.blank?

            structure.bool do
              structure.must do
                query_filters.each do |f|
                  structure.child! do
                    structure.set! f[:name], extract_filters(f[:name], f[:args])
                  end
                end
              end
            end unless query_filters.blank?
          end
        end

        def build_source
          if [true,false].include? source.first
            structure._source source.first
          else
            structure._source do
                structure.include source.first.delete(:include) if source.first.has_key? :include
                structure.exclude source.first.delete(:exclude) if source.first.has_key? :exclude
            end
          end
        end

        def build_sort
          structure.sort sort.flatten.inject(Hash.new) { |h,v| h.merge(v) }
        end

        def build_highlights
          structure.highlight do
            structure.fields do
              highlights.each do |highlight|
                structure.set! highlight, extract_highlighter(highlight)
              end
            end
          end
        end

        def build_filters
          filters.each do |f|
            structure.filter extract_filters(f[:name], f[:args])
          end
        end

        def build_or_filters
          or_filters.each do |f|
            structure.filter extract_filters(f[:name], f[:args])
          end
        end

        def build_aggregations
          structure.aggregations do
            aggregations.each do |agg|
              structure.set! agg[:name], aggregation(agg[:name], agg[:args])
            end
          end
        end

        def build_fields
          structure.fields do
            structure.array! fields.flatten
          end
        end

        def build_search_options
          values[:search_option] ||= []

          opts = extra_search_options
          (values[:search_option] + [opts]).compact.inject(Hash.new) { |h,k,v| h.merge(k) }
        end

        def extra_search_options
          [:size].inject(Hash.new) { |h,k| h[k] = self.send(k) unless self.send(k).nil?; h}
        end

        def compact_where(q, opts = {bool:true})
          return if q.nil?
          if opts.delete(:bool)
            as_must(q)
          else
            as_query_string(q.flatten)
          end
        end

        def as_must(q)
          _must = []
          q.each do |arg|
            arg.each_pair { |k,v| _must << (v.is_a?(Array) ? {terms: Hash[k,v]} : {term: Hash[k,v]}) } if arg.class == Hash
            _must << {term: Hash[[arg.split(/:/).collect(&:strip)]]} if arg.class == String
            _must << arg.first if arg.class == Array
          end
          _must.length == 1 ? _must.first : _must
        end

        def as_query_string(q)
          _and = []

          @query_string_options = q.pop if q.length > 1

          q.each do |arg|
            arg.each_pair { |k,v|  _and << "(#{k}:#{v})" } if arg.class == Hash
            _and << "(#{arg})" if arg.class == String
          end
          _and.join(" AND ")
        end



        def extract_highlighter(highlighter)
          Jbuilder.new do |highlight|
            highlight.extract! highlighter
          end
        end

        def extract_filters(name,opts = {})
          Jbuilder.new do |filter|
              case
              when opts.is_a?(Hash)
                  filter.extract! opts, *opts.keys
              when opts.is_a?(Array)
                  extract_filter_arguments_from_array(filter, opts)
              else
                raise "#filter only accepts Hash or Array"
              end
          end
        end

        def aggregation(name, opts = {})
          Jbuilder.new do |agg|
            case
            when opts.is_a?(Hash)
                agg.extract! opts, *opts.keys
            when opts.is_a?(Array)
                extract_filter_arguments_from_array(agg, opts)
            else
              raise "#aggregation only accepts Hash or Array"
            end
          end
        end

        def extract_filter_arguments_from_array(element, opts)
          opts.each do |opt|
            element.child! do
            element.extract! opt , *opt.keys
            end
          end
        end

      end
    end
  end
end
