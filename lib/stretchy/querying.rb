module Stretchy
  module Querying
    delegate :first, :first!, :last, :last!, :exists?, :has_field?, :any?, :many?, to: :all
    delegate :order, :limit, :size, :sort, :where, :rewhere, :eager_load, :includes,  :create_with, :none, :unscope, to: :all
    delegate :or_filter, :filter, :fields, :source, :highlight, :aggregation, to: :all
    delegate :skip_callbacks, :routing, to: :all
    delegate :search_options, :routing, to: :all
    delegate :must, :must_not, :should, :where_not, :query_string, to: :all

    def fetch_results(es)
      unless es.count?
        base_class.search(es.to_elastic, es.search_options)
      else
        base_class.count(es.to_elastic, es.search_options)
      end
    end


  end
end
