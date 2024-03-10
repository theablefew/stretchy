describe Stretchy::Relations::AggregationMethods do
    let(:model) do
        class TestModel < Stretchy::Record
        end
        TestModel
    end


    let(:relation) { Stretchy::Relation.new(model, {}) }  # create a real instance

    before do
      allow(model).to receive(:all).and_return(relation)
    end
  
    shared_examples 'an aggregation method' do |method, args, expected_args|
      describe "##{method}" do
        before do
          allow(relation).to receive(:aggregation)
        end
  
        it "performs a #{method} aggregation" do
          if args.is_a?(Array)
            model.send(method, :my_agg, *args)
          else 
            model.send(method, :my_agg, args)
          end
          expect(relation).to have_received(:aggregation).with(:my_agg, expected_args)
        end
      end
    end

    it_behaves_like 'an aggregation method', :avg, {field: :price}, {avg: {field: :price}}
    it_behaves_like 'an aggregation method', :bucket_script, {script: "params.tShirtsSold * params.price", buckets_path: {tShirtsSold: "tShirtsSold", price: "price"}}, {bucket_script: {script: "params.tShirtsSold * params.price", buckets_path: {tShirtsSold: "tShirtsSold", price: "price"}}}
    it_behaves_like 'an aggregation method', :bucket_selector, {script: "params.totalSales > 200", buckets_path: {totalSales: "totalSales"}}, {bucket_selector: {script: "params.totalSales > 200", buckets_path: {totalSales: "totalSales"}}}
    it_behaves_like 'an aggregation method', :cardinality, {field: :category}, {cardinality: {field: :category}}
    it_behaves_like 'an aggregation method', :date_histogram, {field: :created_at, interval: 'month'}, {date_histogram: {field: :created_at, interval: 'month'}}
    it_behaves_like 'an aggregation method', :extended_stats, {field: :price}, {extended_stats: {field: :price}}
    it_behaves_like 'an aggregation method', :filter, {term: {category: 'electronics'}}, {filter: {term: {category: 'electronics'}}}
    it_behaves_like 'an aggregation method', :filters, {filters: {electronics: {term: {category: 'electronics'}}, books: {term: {category: 'books'}}}}, {filters: {filters: {electronics: {term: {category: 'electronics'}}, books: {term: {category: 'books'}}}}}
    it_behaves_like 'an aggregation method', :geo_bounds, {field: :location}, {geo_bounds: {field: :location}}
    it_behaves_like 'an aggregation method', :geo_centroid, {field: :location}, {geo_centroid: {field: :location}}
    it_behaves_like 'an aggregation method', :global, {}, {global: {}}
    it_behaves_like 'an aggregation method', :histogram, {field: :price, interval: 10}, {histogram: {field: :price, interval: 10}}
    it_behaves_like 'an aggregation method', :ip_range, {field: :ip, ranges: [{to: '10.0.0.5'}, {from: '10.0.0.5'}]}, {ip_range: {field: :ip, ranges: [{to: '10.0.0.5'}, {from: '10.0.0.5'}]}}
    it_behaves_like 'an aggregation method', :max, {field: :price}, {max: {field: :price}}
    it_behaves_like 'an aggregation method', :min, {field: :price}, {min: {field: :price}}
    it_behaves_like 'an aggregation method', :missing, {field: :price}, {missing: {field: :price}}
    it_behaves_like 'an aggregation method', :nested, {path: 'comments'}, {nested: {path: 'comments'}}
    it_behaves_like 'an aggregation method', :percentile_ranks, {field: :price, values: [100, 200]}, {percentile_ranks: {field: :price, values: [100, 200]}}
    it_behaves_like 'an aggregation method', :percentiles, {field: :price, percents: [25, 50, 75]}, {percentiles: {field: :price, percents: [25, 50, 75]}}
    it_behaves_like 'an aggregation method', :range, {field: :price, ranges: [{to: 100}, {from: 100, to: 200}, {from: 200}]}, {range: {field: :price, ranges: [{to: 100}, {from: 100, to: 200}, {from: 200}]}}
    it_behaves_like 'an aggregation method', :reverse_nested, {}, {reverse_nested: {}}
    it_behaves_like 'an aggregation method', :sampler, {shard_size: 200}, {sampler: {shard_size: 200}}
    it_behaves_like 'an aggregation method', :scripted_metric, {init_script: "_agg['sales'] = 0", map_script: "_agg['sales'] += params.sales", combine_script: "return _agg['sales']", reduce_script: "return _agg['sales']"}, {scripted_metric: {init_script: "_agg['sales'] = 0", map_script: "_agg['sales'] += params.sales", combine_script: "return _agg['sales']", reduce_script: "return _agg['sales']"}}
    it_behaves_like 'an aggregation method', :significant_terms, {field: :category}, {significant_terms: {field: :category}}
    it_behaves_like 'an aggregation method', :stats, {field: :price}, {stats: {field: :price}}
    it_behaves_like 'an aggregation method', :sum, {field: :price}, {sum: {field: :price}}
    it_behaves_like 'an aggregation method', :terms, {field: :category}, {terms: {field: :category}}
    it_behaves_like 'an aggregation method', :top_hits, {size: 1, sort: [{price: 'desc'}]}, {top_hits: {size: 1, sort: [{price: 'desc'}]}}
    it_behaves_like 'an aggregation method', :top_metrics, {metrics: [{field: :price}]},  {top_metrics: {metrics: [{field: :price}]}}
    it_behaves_like 'an aggregation method', :value_count, {field: :price}, {value_count: {field: :price}}
    it_behaves_like 'an aggregation method', :weighted_avg, {value: {field: :price}, weight: {field: :sales}}, {weighted_avg: {value: {field: :price}, weight: {field: :sales}}}

    context 'when passing nested aggregations' do
      it_behaves_like 'an aggregation method', :terms, [{field: :category}, {aggs: {avg_price: {avg: {field: :price}}}}], {terms: {field: :category}, aggs: {avg_price: {avg: {field: :price}}}}
    end

end