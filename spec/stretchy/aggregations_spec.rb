require "spec_helper"

require 'models/resource'

describe "Aggregations" do

    before(:all) do
        resources =  [
            {"name": "John Doe", "email": "john@example.com", "phone": "123-456-7890", "position": {"name": "Software Engineer", "level": "Senior"}, "gender": "male", "age": 30, "income": 100000, "income_after_raise": 0},
            {"name": "Jane Smith", "email": "jane@example.com", "phone": "987-654-3210", "position": {"name": "Product Manager", "level": "Senior"}, "gender": "female", "age": 35, "income": 120000, "income_after_raise": 0},
            {"name": "Michael Johnson", "email": "michael@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Senior"}, "gender": "male", "age": 40, "income": 150000, "income_after_raise": 0},
            {"name": "Emily Davis", "email": "emily@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Senior"}, "gender": "female", "age": 28, "income": 90000, "income_after_raise": 0},
            {"name": "Olivia Wilson", "email": "olivia@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Junior"}, "gender": "female", "age": 32, "income": 80000, "income_after_raise": 0},
            {"name": "Daniel Taylor", "email": "daniel@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Junior"}, "gender": "male", "age": 38, "income": 100000, "income_after_raise": 0},
            {"name": "Sophia Anderson", "email": "sophia@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Junior"}, "gender": "female", "age": 27, "income": 85000, "income_after_raise": 0},
            {"name": "Matthew Martinez", "email": "matthew@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Senior"}, "gender": "male", "age": 33, "income": 110000, "income_after_raise": 0},
            {"name": "Ava Thomas", "email": "ava@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Senior"}, "gender": "female", "age": 30, "income": 120000, "income_after_raise": 0},
            {"name": "Christopher Clark", "email": "christopher@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Senior"}, "gender": "male", "age": 42, "income": 140000, "income_after_raise": 0},
            {"name": "Mia Rodriguez", "email": "mia@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Senior"}, "gender": "female", "age": 29, "income": 95000, "income_after_raise": 0},
            {"name": "Andrew Walker", "email": "andrew@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Junior"}, "gender": "male", "age": 26, "income": 80000, "income_after_raise": 0},
            {"name": "Isabella Lewis", "email": "isabella@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Junior"}, "gender": "female", "age": 31, "income": 90000, "income_after_raise": 0},
            {"name": "Joshua Hall", "email": "joshua@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Junior"}, "gender": "male", "age": 37, "income": 100000, "income_after_raise": 0},
            {"name": "Sophie Young", "email": "sophie@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Junior"}, "gender": "female", "age": 24, "income": 75000, "income_after_raise": 0},
            {"name": "Joseph Turner", "email": "joseph@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Senior"}, "gender": "male", "age": 34, "income": 120000, "income_after_raise": 0},
            {"name": "Chloe Harris", "email": "chloe@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Senior"}, "gender": "female", "age": 33, "income": 130000, "income_after_raise": 0},
            {"name": "David Turner", "email": "david@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Senior"}, "gender": "male", "age": 39, "income": 150000, "income_after_raise": 0},
            {"name": "Emma Allen", "email": "emma@example.com", "phone": "555-987-6543", "position": {"name": "CEO", "level": "Senior"}, "gender": "female", "age": 26, "income": 200000, "income_after_raise": 0}
        ]
        Resource.gateway.client.bulk(body: resources.collect { |r| Resource.new(r).to_bulk })
        Resource.refresh_index!
    end

    after(:all) do
        Resource.delete_index! if Resource.index_exists?
    end

    let(:terms_aggregation) { Resource.size(0).aggregation(:gender, terms: {field: :gender}) }

    it 'returns aggregations' do
        expect(terms_aggregation.aggregations).to be_a(Hash) 
    end

    it 'allows access to named aggregation' do
        # Resource.aggregation(:gender, terms: {field: 'gender.keyword'}).aggregations.gender
        # Resource.aggregation(:gender, terms: {field: 'gender.keyword'}).aggregations.respond_to? :gender
        
        expect(terms_aggregation.aggregations).to respond_to(:gender)
    end




    describe 'bucket aggregations' do
    
        describe 'date_histogram' do
            it 'returns aggregations based on date intervals' do
                # between = 1.year.ago..Time.now
                date_histogram_aggregation = Resource.size(0).aggregation(:volume, 
                    date_histogram: {
                        field: :created_at,
                        calendar_interval: 'day',
                    }
                )

                expect(date_histogram_aggregation.aggregations).to be_a(Hash)
                expect(date_histogram_aggregation.aggregations).to have_key(:volume)
                expect(date_histogram_aggregation.aggregations.volume).to have_key(:buckets)
                expect(date_histogram_aggregation.aggregations.volume.buckets).to be_an(Array)
            end

            it 'returns correct date intervals in the aggregation result' do
                date_histogram_aggregation = Resource.size(0).aggregation(:time, 
                    date_histogram: { 
                        field: :created_at,
                        calendar_interval: 'day' 
                    }
                )
                
                expect(date_histogram_aggregation.aggregations.time.buckets.map(&:key_as_string)).to all(be_a(String))
                expect(expect(date_histogram_aggregation.aggregations.time.buckets.map(&:doc_count)).to all(be_a(Numeric)))
            end
        end



        # Resource.size(0).aggregation(:dates, date_range: {field: :created_at, ranges: [{from: 1.year.ago, to: Time.now}]})
        # {
        #     "to": 1.4436576E12,
        #     "to_as_string": "10-2015",
        #     "doc_count": 7,
        #     "key": "*-10-2015"
        #   }
        describe 'date_range' do
            it 'returns aggregations based on date ranges' do
                date_range_agg = Resource.size(0).aggregation(:dates, 
                    date_range: {
                        field: :created_at,
                        format: "YYYY/MM/dd",
                        ranges: [
                            {from: 1.year.ago.strftime("%Y/%m/%d")},
                            {to: Time.now.strftime("%Y/%m/%d")}
                        ]
                    }
                )

                expect(date_range_agg.aggregations.dates).to be_a(Hash)
                expect(date_range_agg.aggregations.dates.buckets.map(&:to).compact).to all(be_a(Numeric))
                expect(date_range_agg.aggregations.dates.buckets.map(&:from).compact).to all(be_a(Numeric))
                expect(date_range_agg.aggregations.dates.buckets.map(&:to_as_string).compact).to all(be_a(String))
                expect(date_range_agg.aggregations.dates.buckets.map(&:from_as_string).compact).to all(be_a(String))
                expect(date_range_agg.aggregations.dates.buckets.map(&:doc_count)).to all(be_a(Numeric))
                expect(date_range_agg.aggregations.dates.buckets.map { |d| d[:key]}).to all(be_a(String))
            end
        end

        describe 'adjacency_matrix' do
        end

        describe 'auto_date_histogram' do
        end

        describe 'categorize_text' do
        end

        describe 'children' do
        end

        describe 'composite' do
        end

        describe 'diversified_sampler' do
        end

        describe 'filter' do
        end

        describe 'filters' do
        end

        describe 'geo_distance' do
        end

        describe 'geohash_grid' do
        end

        describe 'geotile_grid' do
        end
        
        describe 'global' do
        end

        describe 'histogram' do
        end

        describe 'ip_range' do
        end

        describe 'missing' do
        end

        describe 'multi_terms' do
        end

        describe 'nested' do
        end

        describe 'parent' do
        end

        describe 'range' do
            it 'returns aggregations based on ranges' do
                range_agg = Resource.size(0).aggregation(:age_ranges, 
                    range: {
                        field: :age,
                        ranges: [
                            {to: 30},
                            {from: 30, to: 40},
                            {from: 40}
                        ]
                    }
                )

                expect(range_agg.aggregations.age_ranges).to be_a(Hash)
                expect(range_agg.aggregations.age_ranges.buckets.map(&:to).compact).to all(be_a(Numeric))
                expect(range_agg.aggregations.age_ranges.buckets.map(&:from).compact).to all(be_a(Numeric))
                expect(range_agg.aggregations.age_ranges.buckets.map(&:doc_count)).to all(be_a(Numeric))
                expect(range_agg.aggregations.age_ranges.buckets.map { |d| d[:key]}).to all(be_a(String))
            end
        end

        describe 'rare_terms' do
            it 'returns rare terms' do
                rare_terms_agg = Resource.size(0).aggregation(:rare_positions, 
                    rare_terms: {
                        field: 'position.name'
                    }
                )

                expect(rare_terms_agg.aggregations.rare_positions).to be_a(Hash)
                expect(rare_terms_agg.aggregations.rare_positions).to have_key(:buckets)
                expect(rare_terms_agg.aggregations.rare_positions.buckets).to be_an(Array)
            end
        end

        describe 'reverse_nested' do
        end

        describe 'sampler' do
            it 'returns a sample of documents' do
                sampler_agg = Resource.size(0).aggregation(:sample, 
                    sampler: {
                        shard_size: 100
                    },
                    aggs: {
                        keywords: {
                            significant_terms: {
                                field: 'position.name',
                                exclude: ['senior']
                            }
                        }
                    }
                )


                expect(sampler_agg.aggregations.sample).to be_a(Hash)
                expect(sampler_agg.aggregations.sample).to have_key(:doc_count)
                expect(sampler_agg.aggregations.sample.doc_count).to be_a(Numeric)
            end
        end

        describe 'significant_terms' do
            it 'returns significant terms' do
                significant_terms_agg = Resource.size(0).aggregation(:significant_positions, 
                    significant_terms: {
                        field: 'position.level'
                    }
                )

                expect(significant_terms_agg.aggregations.significant_positions).to be_a(Hash)
                expect(significant_terms_agg.aggregations.significant_positions).to have_key(:buckets)
                expect(significant_terms_agg.aggregations.significant_positions.buckets).to be_an(Array)
            end
        end

        describe 'significant_text' do
        end

        describe 'terms' do
            # {"gender"=>{"doc_count_error_upper_bound"=>0, "sum_other_doc_count"=>0, "buckets"=>[{"key"=>"female", "doc_count"=>10}, {"key"=>"male", "doc_count"=>10}]}} 
            it 'returns terms aggregation' do
                expect(terms_aggregation.aggregations.gender).to be_a(Hash)
                expect(terms_aggregation.aggregations.gender).to have_key(:buckets)
                expect(terms_aggregation.aggregations.gender.buckets).to be_a(Array)
                # buckets should have keys and doc_count
                bucket = terms_aggregation.aggregations.gender.buckets.first
                expect(bucket).to have_key(:key)
                expect(bucket).to have_key(:doc_count)
    
                # key should be a string and one of the expected genders
                expect(bucket[:key]).to be_a(String)
                expect(['male', 'female']).to include(bucket[:key])
    
                # doc_count should be a number and greater than or equal to 0
                expect(bucket[:doc_count]).to be_a(Numeric)
                expect(bucket[:doc_count]).to be >= 0
            end

            #TODO: This should probably live in query_builder_spec.rb
            describe 'aggregation query builder' do

                it 'assumes keyword field if not specified' do
                    query_builder = terms_aggregation.to_elastic
                    expect(query_builder["aggregations"]["gender"]["terms"]["field"]).to eq("gender.keyword")
                    # expect(Resource.aggregation(:gender, terms: {field: :gender}).aggregations).to respond_to(:gender)
                end

                it 'assumes keyword field in nested field if not specified' do
                    query_builder = Resource.size(0).aggregation(:gender, {terms: {field: :gender}, aggs: {position: {terms: {field: 'position.name'}}}}).to_elastic
                    #{"aggregations"=>{"gender"=>{"terms"=>{:field=>"gender.keyword"}, "aggs"=>{:position=>{:terms=>{:field=>"position.name.keyword"}}}}}}
                    expect(query_builder[:aggregations][:gender][:terms][:field].to_s).to eq('gender.keyword')
                    expect(query_builder[:aggregations][:gender][:aggs][:position][:terms][:field].to_s).to eq('position.name.keyword')
                end

                it 'does not assume keyword field if specified' do
                    query_builder = Resource.size(0).aggregation(:gender, terms: {field: 'gender.keyword'}).to_elastic
                    expect(query_builder[:aggregations][:gender][:terms][:field].to_s).to eq('gender.keyword')
                end

                it 'does not assume keyword field unless terms' do
                    query_builder = Resource.size(0).aggregation(:time, date_histogram: { field: :created_at, interval: 'month' }).to_elastic
                    expect(query_builder[:aggregations][:time][:date_histogram][:field].to_s).to eq('created_at')
                end
            end
        end

        describe 'variable_width_histogram' do
        end

    end

    describe 'metrics aggregations' do

        describe 'avg' do
            it 'returns average of a field' do
                avg_agg = Resource.size(0).aggregation(:avg_age, avg: {field: :age})
                expect(avg_agg.aggregations.avg_age).to be_a(Hash)
                expect(avg_agg.aggregations.avg_age).to have_key(:value)
                expect(avg_agg.aggregations.avg_age.value).to be_a(Numeric)
            end
        end

        describe 'boxplot' do
            it 'returns boxplot statistics' do
                boxplot_agg = Resource.size(0).aggregation(:age_stats, boxplot: {field: :age})
                expect(boxplot_agg.aggregations.age_stats).to be_a(Hash)
                expect(boxplot_agg.aggregations.age_stats).to include(:q1, :q3, :min, :max)
                expect(boxplot_agg.aggregations.age_stats.values).to all(be_a(Numeric))
            end
        end

        describe 'cardinality' do
            it 'returns the number of unique values' do
                cardinality_agg = Resource.size(0).aggregation(:unique_positions, cardinality: {field: 'position.name'})
                expect(cardinality_agg.aggregations.unique_positions).to be_a(Hash)
                expect(cardinality_agg.aggregations.unique_positions).to have_key(:value)
                expect(cardinality_agg.aggregations.unique_positions.value).to be_a(Numeric)
                expect(cardinality_agg.aggregations.unique_positions.value).to be > 0
            end
        end

        describe 'extended_stats' do
            # {
            #                 "count" => 19,
            #                 "min" => 24.0,
            #                 "max" => 42.0,
            #                 "avg" => 32.31578947368421,
            #                 "sum" => 614.0,
            #     "sum_of_squares" => 20324.0,
            #         "variance" => 25.373961218836484,
            # "variance_population" => 25.373961218836484,
            # "variance_sampling" => 26.783625730994068,
            #     "std_deviation" => 5.03725731116016,
            # "std_deviation_population" => 5.03725731116016,
            # "std_deviation_sampling" => 5.175289917578924,
            # "std_deviation_bounds" => {
            #             "upper" => 42.390304096004535,
            #             "lower" => 22.24127485136389,
            #     "upper_population" => 42.390304096004535,
            #     "lower_population" => 22.24127485136389,
            #     "upper_sampling" => 42.666369308842064,
            #     "lower_sampling" => 21.965209638526364
            #     }
            # }
            it 'returns extended statistics' do
                extended_stats_agg = Resource.size(0).aggregation(:age_stats, extended_stats: {field: :age})
                expect(extended_stats_agg.aggregations.age_stats).to include(
                    :count, :min, :max, :avg, :sum, :sum_of_squares, :variance,
                    :variance_population, :variance_sampling, :std_deviation,
                    :std_deviation_population, :std_deviation_sampling, :std_deviation_bounds
                )
                expect(extended_stats_agg.aggregations.age_stats.std_deviation_bounds).to include(
                    :upper, :lower, :upper_population, :lower_population, :upper_sampling, :lower_sampling
                )

                expect(extended_stats_agg.aggregations.age_stats.except(:std_deviation_bounds).values).to all(be_a(Numeric))
                expect(extended_stats_agg.aggregations.age_stats.std_deviation_bounds.values).to all(be_a(Numeric))
                

            end
        end

        describe 'geo_bounds' do
        end

        describe 'geo_centroid' do
        end

        describe 'geo_line' do
        end

        describe 'matrix_stats' do
            it 'returns matrix statistics' do
                matrix_stats_agg = Resource.size(0).aggregation(:age_stats, 
                    matrix_stats: {
                        fields: [:age, :income]
                    }
                )
                expect(matrix_stats_agg.aggregations.age_stats).to be_a(Hash)
            end
        end

        describe 'max' do
            it 'returns the maximum value' do
                max_agg = Resource.size(0).aggregation(:max_income, max: {field: :income})
                expect(max_agg.aggregations.max_income).to be_a(Hash)
                expect(max_agg.aggregations.max_income).to have_key(:value)
                expect(max_agg.aggregations.max_income.value).to be_a(Numeric)
            end
        end

        describe 'median_absolute_deviation' do
            it 'returns the median absolute deviation' do
                mad_agg = Resource.size(0).aggregation(:mad_income, median_absolute_deviation: {field: :income})
                expect(mad_agg.aggregations.mad_income).to be_a(Hash)
                expect(mad_agg.aggregations.mad_income).to have_key(:value)
                expect(mad_agg.aggregations.mad_income.value).to be_a(Numeric)
            end
        end

        describe 'min' do
            it 'returns the minimum value' do
                min_agg = Resource.size(0).aggregation(:min_income, min: {field: :income})
                expect(min_agg.aggregations.min_income).to be_a(Hash)
                expect(min_agg.aggregations.min_income).to have_key(:value)
                expect(min_agg.aggregations.min_income.value).to be_a(Numeric)
            end
        end

        describe 'percentile_ranks' do
            it 'returns percentile ranks' do
                percentile_ranks_agg = Resource.size(0).aggregation(:ages, 
                    percentile_ranks: {
                        field: :age,
                        values: [25, 50, 75]
                    }
                )

                expect(percentile_ranks_agg.aggregations.ages).to be_a(Hash)
                expect(percentile_ranks_agg.aggregations.ages).to have_key(:values)
                expect(percentile_ranks_agg.aggregations.ages["values"].values).to all(be_a(Numeric))
            end
        end

        describe 'percentiles' do
            it 'returns percentiles' do
                percentiles_agg = Resource.size(0).aggregation(:ages, 
                    percentiles: {
                        field: :age,
                    }
                )

                expect(percentiles_agg.aggregations.ages).to be_a(Hash)
                expect(percentiles_agg.aggregations.ages).to have_key(:values)
                expect(percentiles_agg.aggregations.ages["values"].values).to all(be_a(Numeric))
            end
        end

        describe 'rate' do
            it 'returns rate' do
                rate_agg = Resource.size(0).aggregation(:by_date, 
                    date_histogram: {
                        field: :created_at,
                        calendar_interval: 'month'
                    },
                    aggs: {
                        avg_income:  {
                            rate: {
                                field: :income,
                                unit: :day
                            }
                        }
                    }
                )


                expect(rate_agg.aggregations.by_date.buckets.first).to be_a(Hash)
                expect(rate_agg.aggregations.by_date.buckets.first).to include(:key_as_string, :doc_count, :avg_income)
                expect(rate_agg.aggregations.by_date.buckets.first.avg_income.value).to be_a(Numeric)
            end
        end

        describe 'scripted_metric' do
            it 'returns scripted metrics' do
                scripted_metric_agg = Resource.size(0).aggregation(:scripted, 
                    scripted_metric: {
                        init_script: "state.transactions = []",
                        map_script: "state.transactions.add(doc['income'].value)",
                        combine_script: "double total = 0; for (t in state.transactions) { total += t } return total",
                        reduce_script: "double total = 0; for (a in states) { total += a } return total"
                    }
                )

                expect(scripted_metric_agg.aggregations.scripted).to be_a(Hash)
                expect(scripted_metric_agg.aggregations.scripted).to have_key(:value)
                expect(scripted_metric_agg.aggregations.scripted.value).to be_a(Numeric)
            end
        end

        describe 'stats' do
            it 'returns statistics' do
                stats_agg = Resource.size(0).aggregation(:age_stats, stats: {field: :age})
                expect(stats_agg.aggregations.age_stats).to be_a(Hash)
                expect(stats_agg.aggregations.age_stats).to include(:count, :min, :max, :avg, :sum)
                expect(stats_agg.aggregations.age_stats.values).to all(be_a(Numeric))
            end
        end

        describe 'string_stats' do
            it 'returns string statistics' do
                string_stats_agg = Resource.size(0).aggregation(:position_stats, string_stats: {field: 'position.name'})
                expect(string_stats_agg.aggregations.position_stats).to be_a(Hash)
                expect(string_stats_agg.aggregations.position_stats).to include(:count, :min_length, :max_length, :avg_length, :entropy)
                expect(string_stats_agg.aggregations.position_stats.values).to all(be_a(Numeric))
            end
        end
        
        describe 'sum' do
            it 'returns the sum of a field' do
                sum_agg = Resource.size(0).aggregation(:total_income, sum: {field: :income})
                expect(sum_agg.aggregations.total_income).to be_a(Hash)
                expect(sum_agg.aggregations.total_income).to have_key(:value)
                expect(sum_agg.aggregations.total_income.value).to be_a(Numeric)
            end
        end

        describe 't_test' do
            it 'returns t-test statistics' do
                t_test_agg = Resource.size(0).aggregation(:t_test, 
                    t_test: {
                        a: {field: :income},
                        b: {field: :income_after_raise}
                    }
                )

                expect(t_test_agg.aggregations.t_test).to be_a(Hash)
                expect(t_test_agg.aggregations.t_test).to include(:value)
                expect(t_test_agg.aggregations.t_test.values).to all(be_a(Numeric))
            end
        end

        describe 'top_hits' do
            it 'returns top hits' do
                top_hits_agg = Resource.size(0).aggregation(:top_hits, 
                    terms: {field: :gender},
                    aggs: {
                        top_hits_gender: {
                            top_hits: {
                                size: 1,
                                sort: [{created_at: {order: :desc}}]
                            }
                        }
                    }
                )

                expect(top_hits_agg.aggregations.top_hits.buckets.first).to be_a(Hash)
                expect(top_hits_agg.aggregations.top_hits.buckets.first).to have_key(:top_hits_gender)
                expect(top_hits_agg.aggregations.top_hits.buckets.first.top_hits_gender).to have_key(:hits)
            end
        end

        describe 'top_metrics' do
            it 'returns top metrics' do
                top_metrics_agg = Resource.size(0).aggregation(:top_metrics, 
                    top_metrics: {
                        metrics: [{field: :income}, {field: :age}],
                        sort: [{income: {order: :desc}}]
                    }
                )

                expect(top_metrics_agg.aggregations.top_metrics).to be_a(Hash)
                expect(top_metrics_agg.aggregations.top_metrics.top).to all(include(:sort, :metrics))
                expect(top_metrics_agg.aggregations.top_metrics.top.first.metrics).to be_a(Hash)
                expect(top_metrics_agg.aggregations.top_metrics.top.first.metrics).to include(:income, :age)
                expect(top_metrics_agg.aggregations.top_metrics.top.first.metrics.values).to all(be_a(Numeric))
            end
        end

        describe 'value_count' do

            it 'returns the count of a field' do
                value_count_agg = Resource.size(0).aggregation(:vcount, value_count: {field: :age})

                expect(value_count_agg.aggregations.vcount).to be_a(Hash)
                expect(value_count_agg.aggregations.vcount).to have_key(:value)
                expect(value_count_agg.aggregations.vcount.value).to be_a(Numeric)
            end

        end

        describe 'weighted_avg' do
            it 'returns weighted average' do
                weighted_avg_agg = Resource.size(0).aggregation(:weighted_avg, 
                    weighted_avg: {
                        value: {field: :income},
                        weight: {field: :age}
                    }
                )
                expect(weighted_avg_agg.aggregations.weighted_avg).to be_a(Hash)
                expect(weighted_avg_agg.aggregations.weighted_avg).to have_key(:value)
                expect(weighted_avg_agg.aggregations.weighted_avg.value).to be_a(Numeric)
            end
        end
    end

    describe 'pipeline aggregations' do

        describe 'avg_bucket' do
            it 'returns average of a bucket' do
                avg_bucket_agg = Resource.size(0).aggregation(:monthly_income, 
                    date_histogram: {
                        field: :created_at,
                        calendar_interval: 'month'
                    },
                    aggs: {
                        salaries: {
                            sum: {field: :income}
                        },
                    }).aggregation(:average_monthly_income, avg_bucket: {buckets_path: "monthly_income>salaries"})
                
                expect(avg_bucket_agg.aggregations.average_monthly_income).to be_a(Hash)
                expect(avg_bucket_agg.aggregations.average_monthly_income).to have_key(:value)
                expect(avg_bucket_agg.aggregations.average_monthly_income.value).to be_a(Numeric)
            end
        end

        describe 'bucket_script' do
        end

        describe 'bucket_count_k_s_test' do
        end

        describe 'bucket_correlation' do
        end

        describe 'bucket_selector' do
        end
        
        describe 'bucket_sort' do
        end

        describe 'cumulative_cardinality' do
        end

        describe 'cumulative_sum' do
        end

        describe 'derivative' do
        end

        describe 'extended_stats_bucket' do
        end

        describe 'inference_bucket' do
        end

        describe 'max_bucket' do
        end

        describe 'min_bucket' do
        end

        describe 'moving_avg' do
        end

        describe 'moving_fn' do
        end

        describe 'moving_percentiles' do
        end

        describe 'normalize' do
        end

        describe 'percentiles_bucket' do
        end

        describe 'serial_diff' do
        end

        describe 'stats_bucket' do
        end

        describe 'sum_bucket' do
        end

    end
end