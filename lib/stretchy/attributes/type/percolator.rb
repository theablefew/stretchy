module Stretchy::Attributes::Type
  # The Percolator attribute type
  #
  # This class is used to define a percolator attribute for a model. 
  #
  # The percolator field type parses a JSON structure into a native query and stores that query,
  # so that the percolate query can use it to match provided documents.
  #
  # Any field that contains a JSON object can be configured to be a percolator field.
  # The percolator field type has no settings. Just configuring the percolator field type
  # is sufficient to instruct Elasticsearch to treat a field as a query.
  #
  # ### Parameters
  #
  # - `type:` `:percolator`.
  # - `options:` The Hash of options for the attribute. This type does not have any specific options.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a percolator attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :query, :percolator
  #   end
  # ```
  #
  class Percolator < Stretchy::Attributes::Type::Base
    def type
      :percolator
    end
  end
end