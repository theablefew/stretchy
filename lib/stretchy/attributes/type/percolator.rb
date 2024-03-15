module Stretchy::Attributes::Type
  # Public: Defines a percolator attribute for the model.
  #
  # The percolator field type parses a JSON structure into a native query and stores that query,
  # so that the percolate query can use it to match provided documents.
  #
  # Any field that contains a JSON object can be configured to be a percolator field.
  # The percolator field type has no settings. Just configuring the percolator field type
  # is sufficient to instruct Elasticsearch to treat a field as a query.
  #
  # Examples
  #
  #   class MyModel < Stretchy::Record
  #     attribute :query, :percolator
  #   end
  #
  # Returns nothing.
  class Percolator < Stretchy::Attributes::Type::Base
    def type
      :percolator
    end
  end
end