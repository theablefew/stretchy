module Stretchy::Attributes::Type
    # The Text attribute type
    #
    # This class is used to define a text attribute for a model. It provides support for the Elasticsearch text data type, which is a type of data type that can hold text strings.
    #
    # >[!NOTE]
    # >
    # > The default for the `:text` type is to have a keyword multified if `field:` is not specified and `fields:` is not explicitly false.
    # > This can be disabled by setting `Stretchy.configuration.add_keyword_field_to_text_attributes` to false.
    # > The default keyword field name is `:keyword`, but this can be changed by setting `Stretchy.configuration.default_keyword_field`.
    #
    # ### Parameters
    #
    # - `type:` `:text`.
    # - `options:` The Hash of options for the attribute.
    #    - `:analyzer:` The String analyzer to be used for the text field, both at index-time and at search-time. Defaults to the default index analyzer, or the standard analyzer.
    #    - `:eager_global_ordinals:` The Boolean indicating if global ordinals should be loaded eagerly on refresh. Defaults to false.
    #    - `:fielddata:` The Boolean indicating if the field can use in-memory fielddata for sorting, aggregations, or scripting. Defaults to false.
    #    - `:fielddata_frequency_filter:` The Hash of expert settings which allow to decide which values to load in memory when fielddata is enabled.
    #    - `:fields:` The Hash of multi-fields allow the same string value to be indexed in multiple ways for different purposes. By default, a 'keyword' field is added. Set to false to disable.
    #    - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
    #    - `:index_options:` The String indicating what information should be stored in the index, for search and highlighting purposes. Defaults to 'positions'.
    #    - `:index_prefixes:` The Hash indicating if term prefixes of between 2 and 5 characters are indexed into a separate field.
    #    - `:index_phrases:` The Boolean indicating if two-term word combinations (shingles) are indexed into a separate field. Defaults to false.
    #    - `:norms:` The Boolean indicating if field-length should be taken into account when scoring queries. Defaults to true.
    #    - `:position_increment_gap:` The Integer indicating the number of fake term position which should be inserted between each element of an array of strings. Defaults to 100.
    #    - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
    #    - `:search_analyzer:` The String analyzer that should be used at search time on the text field. Defaults to the analyzer setting.
    #    - `:search_quote_analyzer:` The String analyzer that should be used at search time when a phrase is encountered. Defaults to the search_analyzer setting.
    #    - `:similarity:` The String indicating which scoring algorithm or similarity should be used. Defaults to 'BM25'.
    #    - `:term_vector:` The String indicating if term vectors should be stored for the field. Defaults to 'no'.
    #    - `:meta:` The Hash of metadata about the field.
    #
    # ---
    #
    # ### Examples
    #
    # #### Define a text attribute
    #
    # ```ruby
    #   class MyModel < StretchyModel
    #     attribute :description, :text, analyzer: 'english'
    #   end
    # ```
    #
    class Text < Stretchy::Attributes::Type::Base
      OPTIONS = [:analyzer, :eager_global_ordinals, :fielddata, :fielddata_frequency_filter, :fields, :index, :index_options, :index_prefixes, :index_phrases, :norms, :position_increment_gap, :store, :search_analyzer, :search_quote_analyzer, :similarity, :term_vector, :meta]

      def initialize(**args)
        # Add a keyword field by default if no fields are specified
        args.reverse_merge!(fields: {keyword: {type: :keyword, ignore_above: 256}}) if args[:fields].nil? && Stretchy.configuration.add_keyword_field_to_text_attributes
        super 
      end

      def type
        :text
      end

      def type_for_database
        :text
      end

      # The default for the `:text` type is to have a keyword field if no fields are specified.
      def keyword_field?
        fields.find { |k,d| d[:type].to_sym == :keyword}.present?
      end

      def mappings(name)
        options = {type: type_for_database}
        OPTIONS.each { |option| options[option] = send(option) unless send(option).nil? }
        options.delete(:fields) if fields == false
        options[:fields] = {keyword: {type: :keyword, ignore_above: 256}} if fields.nil?
        { name => options }.as_json
      end
    end
  end