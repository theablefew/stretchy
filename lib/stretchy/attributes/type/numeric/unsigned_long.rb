module Stretchy::Attributes::Type::Numeric
  # The UnsignedLong attribute type
  #
  # This class is used to define an unsigned_long attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold unsigned long integer values.
  #
  # ### Parameters
  #
  # - `type:` `:unsigned_long`.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define an unsigned_long attribute
  #
  # ```ruby
  #   class MyModel < Stretchy::Record
  #     attribute :large_number, :unsigned_long
  #   end
  # ```
  #
  class UnsignedLong < Base
    def type
      :unsigned_long
    end
  end
end