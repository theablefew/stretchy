module Stretchy::Attributes::Type
  # The MatchOnlyText attribute type
  #
  # This class is used to define a match_only_text attribute for a model. It provides support for the Elasticsearch match_only_text data type, which is a space-optimized variant of text that disables scoring and performs slower on queries that need positions. It is best suited for indexing log messages.
  #
  # ### Parameters
  #
  # - `type:` `:match_only_text`.
  # - `options:` The Hash of options for the attribute. This type does not have any specific options.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a match_only_text attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :log_message, :match_only_text
  #   end
  # ```
  #
  class Nested < Stretchy::Attributes::Type::Base
    OPTIONS = [:dynamic, :properties, :include_in_parent, :include_in_root]

    def type
      :nested
    end
  end
end