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
    class Keyword < Stretchy::Attributes::Type::Base
      OPTIONS = [:doc_values, :eager_global_ordinals, :fields, :ignore_above, :index, :index_options, :meta, :norms, :null_value, :on_script_error, :script, :store, :similarity, :normalizer, :split_queries_on_whitespace, :time_series_dimension]
  
      def type
        :keyword
      end

    end
  end