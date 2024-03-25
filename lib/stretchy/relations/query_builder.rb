module Stretchy
  module Relations
    class QueryBuilder

      attr_reader :structure, :values, :attribute_types, :default_size

      def initialize(values, attribute_types = nil)
        @attribute_types = attribute_types
        @structure = Jbuilder.new ignore_nil: true
        @default_size = values.delete(:default_size)
        @values = values
      end

      def aggregations
        values[:aggregation]
      end

      def filters
        values[:filter_query]
      end

      def or_filters
        values[:or_filter]
      end

      def query
        @query ||= compact_where(values[:where])
      end

      def match_query
        @match_query ||= values[:match]
      end

      def query_strings
        @query_string ||= compact_where(values[:query_string], bool: false)
      end

      def neural_sparse
        @neural_sparse ||= values[:neural_sparse]
      end

      def neural
        @neural ||= values[:neural]
      end

      def hybrid
        @hybrid ||= values[:hybrid]
      end

      def must_nots
        @must_nots ||= compact_where(values[:must_not])
      end

      def shoulds
        @shoulds ||= compact_where(values[:should])
      end

      def ids
        @ids ||= values[:ids]
      end

      def regexes
        @regexes ||= values[:regexp]
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
        values[:filter_query]
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
        build_aggregations(aggregations, structure) unless aggregations.blank?
        structure.attributes!.with_indifferent_access
      end

      private

      def missing_bool_query?
        query.blank? && must_nots.nil? && shoulds.nil? && regexes.nil?
      end

      def missing_query_string?
        query_strings.nil?
      end

      def missing_query_filter?
        query_filters.nil? && or_filters.nil?
      end

      def missing_neural?
        neural_sparse.nil? && neural.nil? && hybrid.nil?
      end

      def no_query?
        missing_bool_query? && missing_query_string? && missing_query_filter? && missing_neural? && ids.nil? && match_query.nil?
      end

      def build_query
        return if no_query?
        structure.query do
          structure.ids do
            structure.values ids.flatten.compact.uniq
          end unless ids.nil?

          structure.match do 
            mq = match_query.dup
            field, value = mq.first.shift
            structure.set! field do
              structure.query value
              structure.extract! mq.last, *mq.last.keys
            end
          end unless match_query.nil?

          structure.hybrid do
            structure.queries do
                hybrid[:neural].each do |n|
                  structure.child! do
                    params = n.dup
                    field_name, query_text = params.shift
                    structure.neural do
                      structure.set! field_name do
                        structure.query_text query_text
                        structure.extract! params, *params.keys
                      end
                    end
                  end
                end

                hybrid[:query].each do |query|
                  structure.child! do
                    structure.extract! query, *query.keys
                  end
                end

            end
          end unless hybrid.nil?

          structure.neural_sparse do
            neural_sparse.each do |args|
              params = args.dup
              field_name, query_text = params.shift
              structure.set! field_name do
                structure.query_text query_text
                structure.extract! params, *params.keys
              end
            end
          end unless neural_sparse.blank?

          structure.neural do
            neural.each do |args|
              params = args.dup
              field_name, query = params.shift
              structure.set! field_name do
                if query.is_a?(Hash)
                  structure.extract! query, *query.keys
                else
                  structure.query_text query
                end
                structure.extract! params, *params.keys
              end
            end
          end unless neural.blank?

          structure.regexp do
            build_regexp 
          end unless regexes.nil?

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

      def build_regexp
        regexes.each do |args|
            target_field = args.first.keys.first
            value_field = args.first.values.first
            structure.set! target_field, args.last.merge(value: value_field)
        end
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

          query_filters.each do |f|
            structure.child! do
              structure.set! f[:name], extract_filters(f[:name], f[:args])
            end
          end unless query_filters.blank?
        end
      end

      def build_source
        if [true,false].include? source.first
          structure._source source.first
        else
          structure._source do
              structure.includes source.first.delete(:includes) if source.first.has_key? :includes
              structure.excludes source.first.delete(:excludes) if source.first.has_key? :excludes
          end
        end
      end

      def build_sort
        structure.sort sort.map { |arg| keyword_transformer.transform(arg) }.flatten
      end

      def build_highlights
        structure.highlight do
          structure.fields do
            highlights.each do |highlight|
              if highlight.is_a?(String) || highlight.is_a?(Symbol)
                structure.set! highlight, {}
              elsif highlight.is_a?(Hash)
                highlight.each_pair do |k,v|
                  structure.set! k, v
                end
              end
            end
          end
        end
      end

      def build_aggregations(aggregation_args, aggregation_structure)
        aggregation_structure.aggregations do
          aggregation_args.each do |agg|
            aggregation_structure.set! agg[:name], aggregation(agg[:name], keyword_transformer.transform(agg[:args], :aggs, :aggregations))
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
        unless self.count?
          values[:size] = size.present? ? size : values[:default_size]
        else 
          values[:size] = nil
        end
        [:size].inject(Hash.new) { |h,k| h[k] = self.send(k) unless self.send(k).nil?; h}
      end

      def compact_where(q, opts = {bool:true})
        return if q.nil?
        if opts.delete(:bool)
          as_must([merge_and_append(q)])
        else
          as_query_string(q.flatten)
        end
      end

      def as_must(q)
        _must = []
        q.each do |arg|
          case arg
          when Hash
            arg = keyword_transformer.transform(arg)
            arg.each_pair do |k,v| 
              # If v is an array, we build a terms query otherwise a term query
              _must << (v.is_a?(Array) ? {terms: Hash[k,v]} : {term: Hash[k,v]}) 
            end
          when String
            _must << {term: Hash[[arg.split(/:/).collect(&:strip)]]}
          when Array
            _must << arg.first
          end
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

      def merge_and_append(queries)
        result = {}
        queries.each do |hash|
          hash.each do |key, value|
            if result[key].is_a?(Array)
              result[key] << value
            elsif result.key?(key)
              result[key] = [result[key], value]
            else
              result[key] = value
            end
          end
        end
        result
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
        Jbuilder.new do |agg_structure|
          case
          when opts.is_a?(Hash)
              nested_agg = opts.delete(:aggs) || opts.delete(:aggregations)

              agg_structure.extract! opts, *opts.keys

              build_aggregations(nested_agg.map {|d| {:name => d.first, :args => d.last } }, agg_structure) if nested_agg
                
          when opts.is_a?(Array)
              extract_filter_arguments_from_array(agg_structure, opts)
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

      def keyword_transformer
        @keyword_transformer ||= Stretchy::Attributes::Transformers::KeywordTransformer.new(@attribute_types)
      end
    end
  end
end
