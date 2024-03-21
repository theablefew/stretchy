module Stretchy
  module Querying
    delegate :exists?, :any?, :many?, :includes, to: :all
    delegate :rewhere, :eager_load, :create_with, :unscoped, to: :all

    delegate *Stretchy::Relations::FinderMethods::METHODS, to: :all
    delegate *Stretchy::Relations::SearchOptionMethods::METHODS, to: :all
    delegate *Stretchy::Relations::QueryMethods.registry, to: :all
    delegate *Stretchy::Relations::AggregationMethods.registry, to: :all


    def fetch_results(es)
      if es.count?
        base_class.count(es.to_elastic, es.search_options)
      else
        base_class.search(es.to_elastic, es.search_options)
      end
    end

  end
end
