module Stretchy
  module Querying
    delegate :first, :first!, :last, :last!, to: :all
    delegate :exists?, :any?, :many?, :includes, to: :all
    delegate :rewhere, :eager_load, :create_with, :none, :unscope, to: :all
    delegate :routing, :search_options, to: :all

    delegate *Stretchy::Relations::QueryMethods.registry, to: :all
    delegate *Stretchy::Relations::AggregationMethods::AGGREGATION_METHODS, to: :all


    def fetch_results(es)
      if es.count?
        base_class.count(es.to_elastic, es.search_options)
      else
        base_class.search(es.to_elastic, es.search_options)
      end
    end

  end
end
