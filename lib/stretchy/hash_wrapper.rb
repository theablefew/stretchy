module Stretchy
  # A Hash with method access to its keys, used for search responses and hash attributes.
  #
  # ```ruby
  #   Stretchy::HashWrapper.new("hits" => { "total" => 1 }).hits.total # => 1
  # ```
  class HashWrapper < ::Hashie::Mash
    disable_warnings if respond_to?(:disable_warnings)
  end
end
