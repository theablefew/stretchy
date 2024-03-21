module Stretchy
  module Relations
    module AggregationMethods
      module SignificantTerms
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

        AggregationMethods.register!(:significant_terms)

      end
    end
  end
end