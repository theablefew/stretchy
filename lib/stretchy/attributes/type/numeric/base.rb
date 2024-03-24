module Stretchy::Attributes::Type::Numeric
  # The Base class for numeric attribute types
  #
  # This class is used to define a base for numeric attribute types for a model. It provides support for the Elasticsearch numeric data types, which are types of data that can hold numeric values.
  #
  # ### Parameters
  #
  # - `options:` The Hash of options for the attribute.
  #    - `:coerce:` The Boolean indicating if strings should be converted to numbers and fractions truncated for integers. Defaults to true.
  #    - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.
  #    - `:ignore_malformed:` The Boolean indicating if malformed numbers should be ignored. Defaults to false.
  #    - `:index:` The Boolean indicating if the field should be quickly searchable. Defaults to true.
  #    - `:meta:` The Hash metadata about the field.
  #    - `:null_value:` The Numeric value to be substituted for any explicit null values. Defaults to null.
  #    - `:on_script_error:` The String defining what to do if the script defined by the :script parameter throws an error at indexing time. Can be 'fail' or 'continue'.
  #    - `:script:` The String script that will index values generated by this script, rather than reading the values directly from the source.
  #    - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
  #    - `:time_series_dimension:` The Boolean indicating if the field is a time series dimension. Defaults to false.
  #    - `:time_series_metric:` The String indicating if the field is a time series metric. Can be 'counter', 'gauge', or 'null'.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a numeric attribute
  #
  # ```ruby
  #   class MyModel < Stretchy::Record
  #     attribute :age, :integer, coerce: false, time_series_dimension: true
  #   end
  # ```
  #
  class Base < Stretchy::Attributes::Type::Base #:nodoc:
    OPTIONS = [:coerce, :doc_values, :ignore_malformed, :index, :meta, :null_value, :on_script_error, :script, :store, :time_series_dimension, :time_series_metric] + self.superclass::OPTIONS

    def type
      raise NotImplementedError, "You must use one of the numeric types: integer, long, short, byte, double, float, half_float, scaled_float."
    end
  end
end