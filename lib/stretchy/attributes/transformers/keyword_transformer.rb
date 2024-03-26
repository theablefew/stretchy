module Stretchy
  module Attributes
    module Transformers
      # Applies transformations to keyword fields in queries
      #
      # ### Examples
      #
      # ```ruby
      # class Goat < StretchyModel
      #  attribute :name, :keyword
      #  attribute :age, :integer
      # end
      # 
      # Goat.where(name: 'billy').to_elastic
      # # => {query: {term: {'name.keyword': 'billy'}}}
      #
      # ```
      class KeywordTransformer

          KEYWORD_AGGREGATION_KEYS = [:terms, :rare_terms, :significant_terms, :cardinality, :string_stats]

          attr_reader :attribute_types

          def initialize(attribute_types)
            @attribute_types = attribute_types
          end

          def cast_value_keys
            values.transform_values do |value|
              case value
              when Array
                value.map { |item| transform_keys_for_item(item) }
              when Hash
                transform_keys_for_item(value)
              else
                value
              end
            end
          end
          
          def keyword_available?(arg)
            attrib = @attribute_types[arg.to_s.split(".").first] 
            return false unless attrib 
            attrib.respond_to?(:keyword_field?) && attrib.keyword_field?
          end

          def keyword_field_for(arg)
            attrib = @attribute_types[arg.to_s.split(".").first]
            keyword_field = attrib.respond_to?(:fields) ? attrib.fields.find { |k,d| d[:type].to_sym == :keyword }&.first : nil
            keyword_field || Stretchy.configuration.default_keyword_field
          end

          def protected?(arg)
            return false if arg.nil?
            Stretchy::Relations::AggregationMethods.registry.include?(arg.to_sym)
          end
          
          # Add `.keyword` to attributes that have a keyword subfield but aren't `:keywords`
          # this is for text fields that have a keyword subfield
          # `:text` and `:string` fields add a `:keyword` subfield to the attribute mapping automatically
          def transform(item, *ignore) 
            return item unless Stretchy.configuration.auto_target_keywords
            if item.is_a?(String)
              return (!protected?(item) && keyword_available?(item)) ? "#{item}.#{keyword_field_for(item)}" : item 
            end
            item.each_with_object({}) do |(key, value), new_item|
              if ignore && ignore.include?(key)
                new_item[key] = value
                next
              end

              new_key = (!protected?(key) && keyword_available?(key)) ? "#{key}.#{keyword_field_for(key)}" : key

              new_value = value
          
              if new_value.is_a?(Hash)
                new_value = transform(new_value, *ignore)
              elsif new_value.is_a?(Array)
                new_value = new_value.map { |i| i.is_a?(Hash) ? transform(i, *ignore) : i }
              elsif new_value.is_a?(String) || new_value.is_a?(Symbol) 
                new_value = "#{new_value}.#{keyword_field_for(new_value)}" if keyword_available?(new_value) && new_value.to_s !~  Regexp.new("\.#{keyword_field_for(new_value)}$")
              end

              new_item[new_key] = new_value
            end
          end

      end
    end
  end
end
