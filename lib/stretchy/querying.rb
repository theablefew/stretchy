module Stretchy
  module Querying
    delegate :first, :first!, :last, :last!, :exists?, :has_field, :any?, :many?, to: :all
    delegate :order, :limit, :size, :sort, :rewhere, :eager_load, :includes,  :create_with, :none, :unscope, to: :all
    delegate :or_filter, :fields, :source, :highlight, to: :all
    delegate :neural_sparse, :neural, :hybrid, to: :all
    delegate *Stretchy::Relations::AggregationMethods::AGGREGATION_METHODS, to: :all

    delegate :skip_callbacks, :routing, :search_options, to: :all
    delegate :must, :must_not, :should, :where_not, :where, :filter_query, :query_string, :regexp, to: :all

    def fetch_results(es)
      if es.count?
        base_class.count(es.to_elastic, es.search_options)
      else
        base_class.search(es.to_elastic, es.search_options)
      end
    end


  end
end
