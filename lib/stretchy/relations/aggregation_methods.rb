module Stretchy
    module Relations
        module AggregationMethods 

            AGGREGATION_METHODS = [
              :aggregation,
              :avg,
              :bucket_script,
              :bucket_selector,
              :bucket_sort,
              :cardinality,
              :children,
              :composite,
              :date_histogram,
              :date_range,
              :extended_stats,
              :filter, # filter is a query method 
              :filters,
              :geo_bounds,
              :geo_centroid,
              :global,
              :histogram,
              :ip_range,
              :max,
              :min,
              :missing,
              :nested,
              :percentile_ranks,
              :percentiles,
              :range,
              :reverse_nested,
              :sampler,
              :scripted_metric,
              :significant_terms,
              :stats,
              :sum,
              :terms,
              :top_hits,
              :top_metrics,
              :value_count,
              :weighted_avg
            ].freeze

            # Adds an aggregation to the query.
            #
            # @param name [Symbol, String] the name of the aggregation
            # @param options [Hash] a hash of options for the aggregation
            # @param block [Proc] an optional block to further configure the aggregation
            #
            # @example
            #   Model.aggregation(:avg_price, field: :price)
            #   Model.aggregation(:price_ranges) do
            #     range field: :price, ranges: [{to: 100}, {from: 100, to: 200}, {from: 200}]
            #   end
            #
            # Aggregation results are available in the `aggregations` method of the results under name provided in the aggregation.
            #
            # @example
            #  results = Model.where(color: :blue).aggregation(:avg_price, field: :price)
            #  results.aggregations.avg_price
            #
            # @return [Stretchy::Relation] a new relation
            def aggregation(name, options = {}, &block)
                spawn.aggregation!(name, options, &block)
            end

            def aggregation!(name, options = {}, &block) # :nodoc:
                self.aggregation_values += [{name: name, args: assume_keyword_field(options)}]
                self
            end



            # Public: Perform an avg aggregation.
            #
            # name    - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to calculate the average on.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.aggregation(:average_price, field: :price)
            #
            # Returns a new Stretchy::Relation.
            def avg(name, options = {}, *aggs)
                options = {avg: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a bucket_script aggregation.
            #
            # name    - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :buckets_path - The paths to the buckets.
            #           :script       - The script to execute.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.aggregation(:total_sales, script: "params.tShirtsSold * params.price", buckets_path: {tShirtsSold: "tShirtsSold", price: "price"})
            #
            # Returns a new Stretchy::Relation.
            def bucket_script(name, options = {}, *aggs)
            options = {bucket_script: options}.merge(*aggs)
            aggregation(name, options)
            end

            # Public: Perform a bucket_selector aggregation.
            #
            # name    - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :script - The script to determine whether the current bucket will be retained.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.aggregation(:sales_bucket_filter, script: "params.totalSales > 200", buckets_path: {totalSales: "totalSales"})
            #
            # Returns a new Stretchy::Relation.
            def bucket_selector(name, options = {}, *aggs)
            options = {bucket_selector: options}.merge(*aggs)
            aggregation(name, options)
            end

            # Public: Perform a bucket_sort aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to sort on.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.bucket_sort(:my_agg, {field: 'my_field'})
            #   Model.bucket_sort(:my_agg, {field: 'my_field'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def bucket_sort(name, options = {}, *aggs)
                options = {bucket_sort: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a cardinality aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to perform the aggregation on.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.cardinality(:unique_names, {field: 'names'})
            #   Model.cardinality(:unique_names, {field: 'names'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def cardinality(name, options = {}, *aggs)
                options = {cardinality: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a children aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :type - The type of children to aggregate.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.children(:my_agg, {type: 'my_type'})
            #   Model.children(:my_agg, {type: 'my_type'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def children(name, options = {}, *aggs)
                options = {children: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a composite aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :sources - The sources to use for the composite aggregation.
            #           :size - The size of the composite aggregation.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.composite(:my_agg, {sources: [...], size: 100})
            #   Model.composite(:my_agg, {sources: [...], size: 100}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def composite(name, options = {}, *aggs)
                options = {composite: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a date_histogram aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the date_histogram aggregation.
            #           :interval - The interval for the date_histogram aggregation.
            #           :calendar_interval - The calendar interval for the date_histogram aggregation.
            #           :format - The format for the date_histogram aggregation.
            #           :time_zone - The time zone for the date_histogram aggregation.
            #           :min_doc_count - The minimum document count for the date_histogram aggregation.
            #           :extended_bounds - The extended bounds for the date_histogram aggregation.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.date_histogram(:my_agg, {field: 'date', interval: 'month', format: 'MM-yyyy', time_zone: 'UTC'})
            #   Model.date_histogram(:my_agg, {field: 'date', calendar_interval: :month, format: 'MM-yyyy', time_zone: 'UTC'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def date_histogram(name, options = {}, *aggs)
                options = {date_histogram: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a date_range aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the date_range aggregation.
            #           :format - The format for the date_range aggregation.
            #           :time_zone - The time zone for the date_range aggregation.
            #           :ranges - The ranges for the date_range aggregation.
            #           :keyed - The keyed option for the date_range aggregation.
            # aggs - The Hash of nested aggregations.
            #
            # Examples
            #
            #   Model.date_range(:my_agg, {field: 'date', format: 'MM-yyyy', time_zone: 'UTC', ranges: [{to: 'now', from: 'now-1M'}]})
            #   Model.date_range(:my_agg, {field: 'date', format: 'MM-yyyy', time_zone: 'UTC', ranges: [{to: 'now', from: 'now-1M'}]}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def date_range(name, options = {}, *aggs)
                options = {date_range: options}.merge(*aggs)
                aggregation(name, options)
            end
            # Public: Perform an extended_stats aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the extended_stats aggregation.
            #           :sigma - The sigma for the extended_stats aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.extended_stats(:my_agg, {field: 'field_name', sigma: 1.0})
            #   Model.extended_stats(:my_agg, {field: 'field_name', sigma: 1.0}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def extended_stats(name, options = {}, *aggs)
                options = {extended_stats: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a filter_agg aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :filter - The filter to use for the filter_agg aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.filter_agg(:my_agg, {filter: {...}})
            #   Model.filter_agg(:my_agg, {filter: {...}}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def filter(name, options = {}, *aggs)
                options = {filter: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a filters aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :filters - The filters to use for the filters aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.filters(:my_agg, {filters: {...}})
            #   Model.filters(:my_agg, {filters: {...}}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def filters(name, options = {}, *aggs)
                options = {filters: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a geo_bounds aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the geo_bounds aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.geo_bounds(:my_agg, {field: 'location_field'})
            #   Model.geo_bounds(:my_agg, {field: 'location_field'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def geo_bounds(name, options = {}, *aggs)
                options = {geo_bounds: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a geo_centroid aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the geo_centroid aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.geo_centroid(:my_agg, {field: 'location_field'})
            #   Model.geo_centroid(:my_agg, {field: 'location_field'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def geo_centroid(name, options = {}, *aggs)
                options = {geo_centroid: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a global aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}).
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.global(:my_agg)
            #   Model.global(:my_agg, {}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def global(name, options = {}, *aggs)
                options = {global: options}.merge(*aggs)
                aggregation(name, options)
            end
            # Public: Perform a histogram aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the histogram aggregation.
            #           :interval - The interval for the histogram aggregation.
            #           :min_doc_count - The minimum document count for the histogram aggregation.
            #           :extended_bounds - The extended bounds for the histogram aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.histogram(:my_agg, {field: 'field_name', interval: 5})
            #   Model.histogram(:my_agg, {field: 'field_name', interval: 5}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def histogram(name, options = {}, *aggs)
                options = {histogram: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform an ip_range aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the ip_range aggregation.
            #           :ranges - The ranges to use for the ip_range aggregation. ranges: [{to: '10.0.0.5'}, {from: '10.0.0.5'}]
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.ip_range(:my_agg, {field: 'ip_field'})
            #   Model.ip_range(:my_agg, {field: 'ip_field'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def ip_range(name, options = {}, *aggs)
                options = {ip_range: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a max aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the max aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.max(:my_agg, {field: 'field_name'})
            #   Model.max(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def max(name, options = {}, *aggs)
                options = {max: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a min aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the min aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.min(:my_agg, {field: 'field_name'})
            #   Model.min(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def min(name, options = {}, *aggs)
                options = {min: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a missing aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the missing aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.missing(:my_agg, {field: 'field_name'})
            #   Model.missing(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def missing(name, options = {}, *aggs)
                options = {missing: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a nested aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :path - The path to use for the nested aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.nested(:my_agg, {path: 'path_to_field'})
            #   Model.nested(:my_agg, {path: 'path_to_field'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def nested(name, options = {}, *aggs)
                options = {nested: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a percentile_ranks aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the percentile_ranks aggregation.
            #           :values - The values to use for the percentile_ranks aggregation.
            #           :keyed -  associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true
            #           :script - The script to use for the percentile_ranks aggregation. (optional)  script: {source: "doc['field_name'].value", lang: "painless"}
            #           :hdr - The hdr to use for the percentile_ranks aggregation. (optional) hdr: {number_of_significant_value_digits: 3}
            #           :missing - The missing to use for the percentile_ranks aggregation. (optional) missing: 10
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]})
            #   Model.percentile_ranks(:my_agg, {field: 'field_name', values: [1, 2, 3]}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def percentile_ranks(name, options = {}, *aggs)
                options = {percentile_ranks: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a percentiles aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the percentiles aggregation.
            #           :percents - The percents to use for the percentiles aggregation. percents: [95, 99, 99.9]
            #           :keyed - associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true
            #           :tdigest - The tdigest to use for the percentiles aggregation. (optional) tdigest: {compression: 100, execution_hint: "high_accuracy"}
            #                   :compression - The compression factor to use for the t-digest algorithm. A higher compression factor will yield more accurate percentiles, but will require more memory. The default value is 100.
            #                   :execution_hint - The execution_hint to use for the t-digest algorithm. (optional) execution_hint: "auto"
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.percentiles(:my_agg, {field: 'field_name', percents: [1, 2, 3]})
            #   Model.percentiles(:my_agg, {field: 'field_name', percents: [1, 2, 3]}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def percentiles(name, options = {}, *aggs)
                options = {percentiles: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a range aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the range aggregation.
            #           :ranges - The ranges to use for the range aggregation.
            #           :keyed - associates a unique string key with each bucket and returns the ranges as a hash rather than an array. default: true
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.range(:my_agg, {field: 'field_name', ranges: [{from: 1, to: 2}, {from: 2, to: 3}]})
            #   Model.range(:my_agg, {field: 'field_name', ranges: [{from: 1, to: 2}, {from: 2, to: 3}]}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def range(name, options = {}, *aggs)
                options = {range: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a reverse_nested aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}).
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.reverse_nested(:my_agg)
            #   Model.reverse_nested(:my_agg, {}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def reverse_nested(name, options = {}, *aggs)
                options = {reverse_nested: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a sampler aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :shard_size - The shard size to use for the sampler aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.sampler(:my_agg, {shard_size: 100})
            #   Model.sampler(:my_agg, {shard_size: 100}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def sampler(name, options = {}, *aggs)
                options = {sampler: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a scripted_metric aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :init_script - The initialization script for the scripted_metric aggregation.
            #           :map_script - The map script for the scripted_metric aggregation.
            #           :combine_script - The combine script for the scripted_metric aggregation.
            #           :reduce_script - The reduce script for the scripted_metric aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.scripted_metric(:my_agg, {init_script: '...', map_script: '...', combine_script: '...', reduce_script: '...'})
            #   Model.scripted_metric(:my_agg, {init_script: '...', map_script: '...', combine_script: '...', reduce_script: '...'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def scripted_metric(name, options = {}, *aggs)
                options = {scripted_metric: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a significant_terms aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the significant_terms aggregation.
            #           :background_filter - The background filter to use for the significant_terms aggregation.
            #           :mutual_information - The mutual information to use for the significant_terms aggregation.
            #           :chi_square - The chi square to use for the significant_terms aggregation.
            #           :gnd - The gnd to use for the significant_terms aggregation.
            #           :jlh - The jlh to use for the significant_terms aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.significant_terms(:my_agg, {field: 'field_name'})
            #   Model.significant_terms(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def significant_terms(name, options = {}, *aggs)
                options = {significant_terms: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a stats aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the stats aggregation.
            #           :missing - The missing to use for the stats aggregation.
            #           :script - The script to use for the stats aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.stats(:my_agg, {field: 'field_name'})
            #   Model.stats(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def stats(name, options = {}, *aggs)
                options = {stats: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a sum aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the sum aggregation.
            #           :missing - The missing to use for the sum aggregation.
            #           :script - The script to use for the sum aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.sum(:my_agg, {field: 'field_name'})
            #   Model.sum(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def sum(name, options = {}, *aggs)
                options = {sum: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a terms aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the terms aggregation.
            #           :size - The size for the terms aggregation. (optional)
            #           :min_doc_count - The minimum document count for the terms aggregation. (optional)
            #           :shard_min_doc_count - The shard minimum document count for the terms aggregation. (optional)
            #           :show_term_doc_count_error - The show_term_doc_count_error for the terms aggregation. (optional) default: false
            #           :shard_size - The shard size for the terms aggregation. (optional)
            #           :order - The order for the terms aggregation. (optional)
            #           
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.terms(:my_agg, {field: 'field_name', size: 10, min_doc_count: 1, shard_size: 100})
            #   Model.terms(:my_agg, {field: 'field_name', size: 10, min_doc_count: 1, shard_size: 100}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def terms(name, options = {}, *aggs)
                options = {terms: options}.merge(*aggs)
                aggregation(name, options)
            end


            # Public: Perform a top_hits aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :size - The size for the top_hits aggregation.
            #           :from - The from for the top_hits aggregation.
            #           :sort - The sort for the top_hits aggregation.
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.top_hits(:my_agg, {size: 10, sort: {...}})
            #   Model.top_hits(:my_agg, {size: 10, sort: {...}}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def top_hits(name, options = {}, *aggs)
                options = {top_hits: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a top_metrics aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :metrics - The metrics to use for the top_metrics aggregation. metrics: [{field: 'field_name', type: 'max'}, {field: 'field_name', type: 'min']
            #           :field - The field to use for the top_metrics aggregation. (optional)
            #           :size - The size for the top_metrics aggregation. (optional)
            #           :sort - The sort for the top_metrics aggregation. (optional)
            #           :missing - The missing for the top_metrics aggregation. (optional)
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.top_metrics(:my_agg, {metrics: ['metric1', 'metric2']})
            #   Model.top_metrics(:my_agg, {metrics: ['metric1', 'metric2']}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def top_metrics(name, options = {}, *aggs)
                options = {top_metrics: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a value_count aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :field - The field to use for the value_count aggregation.
            #           :script - The script to use for the value_count aggregation. (optional) script: {source: "doc['field_name'].value", lang: "painless"}
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.value_count(:my_agg, {field: 'field_name'})
            #   Model.value_count(:my_agg, {field: 'field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def value_count(name, options = {}, *aggs)
                options = {value_count: options}.merge(*aggs)
                aggregation(name, options)
            end

            # Public: Perform a weighted_avg aggregation.
            #
            # name - The Symbol or String name of the aggregation.
            # options - The Hash options used to refine the aggregation (default: {}):
            #           :value - The value field to use for the weighted_avg aggregation. {value: { field: 'price', missing: 0}}
            #           :weight - The weight field to use for the weighted_avg aggregation. {weight: { field: 'weight', missing: 0}}
            #           :format - The format for the weighted_avg aggregation. (optional)
            # aggs - The Array of additional nested aggregations (optional).
            #
            # Examples
            #
            #   Model.weighted_avg(:my_agg, {value_field: 'value_field_name', weight_field: 'weight_field_name'})
            #   Model.weighted_avg(:my_agg, {value_field: 'value_field_name', weight_field: 'weight_field_name'}, aggs: {...})
            #
            # Returns a new Stretchy::Relation.
            def weighted_avg(name, options = {}, *aggs)
                options = {weighted_avg: options}.merge(*aggs)
                aggregation(name, options)
            end
            

        end
    end
end