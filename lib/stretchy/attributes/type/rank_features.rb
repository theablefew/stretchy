module Stretchy::Attributes::Type
  # Public: Defines a rank_features attribute for the model.
  #
  # A rank_features field can index numeric feature vectors, so that they can later be used to boost documents in queries with a rank_feature query.

  # It is analogous to the rank_feature data type but is better suited when the list of features is sparse so that it wouldn’t be reasonable to add one field to the mappings for each of them.
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :positive_score_impact - The Boolean indicating if features correlate positively with the score. If set to false, the score decreases with the value of the feature instead of increasing. Defaults to true.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :negative_reviews, :rank_features, positive_score_impact: false
  #   end
  #
  # Returns nothing.
  class RankFeatures < Stretchy::Attributes::Type::Hash
    OPTIONS = [:positive_score_impact]

    def mappings(name)
      options = {}
      OPTIONS.each { |option| options[option] = send(option) unless send(option).nil? }
      { name =>  options }.as_json 
    end

    def type
      :rank_features
    end
  end
end