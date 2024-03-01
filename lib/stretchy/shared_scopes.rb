module Stretchy
    module SharedScopes
        extend ActiveSupport::Concern

        included do
            scope :between, lambda { |range| filter(:range, "date" => {gte: range.begin, lte: range.end}) }
        end

    end
end