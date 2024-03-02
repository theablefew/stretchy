module Stretchy
    module SharedScopes
        extend ActiveSupport::Concern

        included do

            scope :between, lambda { |range| filter(:range, "date" => {gte: range.begin, lte: range.end}) }
            scope :using_time_based_indices, lambda { |range| search_options(index: time_based_indices(range)) }

        end

        class_methods do
                
            #   Helpful when you want to search across multiple indices when there are 
            #   many indices for a given model. It significantly reduces the load on the cluster. 
            #
            #   @example Narrow search across indices for the last 2 months
            #   
            #       class Twitter < Stretchy::Model
            #          scope :monthly_indices, lambda { |range| search_options(index: time_based_indices(range)) }
            #       end 
            #
            #       Twitter.monthly_indices(2.months.ago..1.day.ago)
            #       => search_url:  "/twitter_2024_01*,twitter_2024_02*,twitter_2024_03*/_search" 
            #
            def time_based_indices(range, format = "%Y_%m")
                (range.begin.to_datetime...range.end.to_datetime).map do |d| 
                    "#{self.index_name.gsub(/\*/, "")}#{d.utc.strftime("#{format}*")}" 
                end.uniq.join(",")                
            end
    
        end
    end
end