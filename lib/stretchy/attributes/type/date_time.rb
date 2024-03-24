module Stretchy::Attributes::Type
  # The DateTime attribute type
  #
  # This class is used to define a datetime attribute for a model. It provides support for the Elasticsearch date data type, which is a type of data type that can hold dates.
  #
  # ### Parameters
  #
  # - `type:` `:datetime`.
  # - `options:` The Hash of options for the attribute.
  #    - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.
  #    - `:format:` The String date format(s) that can be parsed. Defaults to 'strict_date_optional_time||epoch_millis'.
  #    - `:locale:` The String locale to use when parsing dates. Defaults to the ROOT locale.
  #    - `:ignore_malformed:` The Boolean indicating if malformed numbers should be ignored. Defaults to false.
  #    - `:index:` The Boolean indicating if the field should be quickly searchable. Defaults to true.
  #    - `:null_value:` The Date value to be substituted for any explicit null values. Defaults to null.
  #    - `:on_script_error:` The String defining what to do if the script defined by the :script parameter throws an error at indexing time. Can be 'fail' or 'continue'.
  #    - `:script:` The String script that will index values generated by this script, rather than reading the values directly from the source.
  #    - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
  #    - `:meta:` The Hash metadata about the field.
  #
  # ---
  #
  # ### Examples
  #
  # #### Define a datetime attribute
  #
  # ```ruby
  #   class MyModel < StretchyModel
  #     attribute :created_at, :datetime, format: 'strict_date_optional_time||epoch_millis', locale: 'en'
  #   end
  # ```
  #
  class DateTime < Stretchy::Attributes::Type::Base
    OPTIONS = [:doc_values, :format, :locale, :ignore_malformed, :index, :null_value, :on_script_error, :script, :store, :meta]
    attr_reader *OPTIONS + self.superclass::OPTIONS
    include ActiveModel::Type::Helpers::Timezone
    include ActiveModel::Type::Helpers::AcceptsMultiparameterTime.new(
      defaults: { 4 => 0, 5 => 0 }
    )
    include ActiveModel::Type::Helpers::TimeValue

    def initialize(**args)
      @model_format = args.delete(:model_format)
      super
    end

    def type
      :datetime
    end

    # Returns the type `:date` for the database.
    #
    def type_for_database
      :date
    end

    private
    def cast_value(value)
      return apply_seconds_precision(value) unless value.is_a?(::String)
      return if value.empty?

      fast_string_to_time(value) || fallback_string_to_time(value) || custom_string_to_time(value)
    end

    # '0.123456' -> 123456
    # '1.123456' -> 123456
    def microseconds(time)
      time[:sec_fraction] ? (time[:sec_fraction] * 1_000_000).to_i : 0
    end

    def custom_string_to_time(string)
      ::Date.strptime(string, @model_format)
    end

    def fallback_string_to_time(string)
      time_hash = begin
        ::Date._parse(string)
      rescue ArgumentError => e
      end
      return unless time_hash

      time_hash[:sec_fraction] = microseconds(time_hash)

      new_time(*time_hash.values_at(:year, :mon, :mday, :hour, :min, :sec, :sec_fraction, :offset))
    end

    def value_from_multiparameter_assignment(values_hash)
      missing_parameters = [1, 2, 3].delete_if { |key| values_hash.key?(key) }
      unless missing_parameters.empty?
        raise ArgumentError, "Provided hash #{values_hash} doesn't contain necessary keys: #{missing_parameters}"
      end
      super
    end

  end
end