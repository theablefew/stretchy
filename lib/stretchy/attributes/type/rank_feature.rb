module Stretchy::Attributes::Type
  # Public: Defines a rank_feature attribute for the model.
  #
  # opts - The Hash options used to refine the attribute (default: {}):
  #        :positive_score_impact - The Boolean indicating if features correlate positively with the score. If set to false, the score decreases with the value of the feature instead of increasing. Defaults to true.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :url_length, :rank_feature, positive_score_impact: false
  #   end
  #
  # Returns nothing.
  class RankFeature < Stretchy::Attributes::Type::Base
    OPTIONS = [:positive_score_impact]

    def type
      :rank_feature
    end
  end
end