module Stretchy::Attributes::Type
  # Public: Defines a join attribute for the model.
  #
  # opts - The Hash options used to define the parent/child relation within documents of the same index (default: {}):
  #        :relations - The Hash defining a set of possible relations within the documents, each relation being a parent name and a child name.
  #
  # Examples
  #
  #   class MyModel
  #     include StretchyModel
  #     attribute :relation, :join, relations: { question: :answer }
  #   end
  #
  # Returns nothing.
  class Join < Stretchy::Attributes::Type::Base
    OPTIONS = [:relations]

    def type
      :join
    end
  end
end