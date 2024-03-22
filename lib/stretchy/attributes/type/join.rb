module Stretchy::Attributes::Type
  # The Join attribute type
  #
  # This class is used to define a join attribute for a model. It provides support for the Elasticsearch join data type, which is a type of data type that can hold parent/child relationships within documents of the same index.
  #
  # ### Parameters
  #
  # - `type:` `:join`.
  # - `options:` The Hash of options for the attribute.
  #    - `:relations:` The Hash defining a set of possible relations within the documents, each relation being a parent name and a child name.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a join attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :relation, :join, relations: { question: :answer }
  #   end
  # ```
  #
  class Join < Stretchy::Attributes::Type::Base
    OPTIONS = [:relations]

    def type
      :join
    end
  end
end