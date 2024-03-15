# a space-optimized variant of text that disables scoring and performs slower on queries that need positions. It is best suited for indexing log messages.
module Stretchy::Attributes::Type
  class MatchOnlyText < Stretchy::Attributes::Type::Text
    def type
      :match_only_text
    end
  end
end