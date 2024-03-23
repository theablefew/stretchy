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
          
          def keyword?(arg)
            attr = @attribute_types[arg.to_s] 
            return false unless attr && @attribute_types.has_key?(arg.to_s)
            attr.respond_to?(:keyword_field?) && attr.keyword_field?
          end

          def protected?(arg)
            return false if arg.nil?
            Stretchy::Relations::AggregationMethods.registry.include?(arg.to_sym)
          end
          
          # Add `.keyword` to attributes that have a keyword subfield but aren't `:keywords`
          # this is for text fields that have a keyword subfield
          # `:text` and `:string` fields add a `:keyword` subfield to the attribute mapping automatically
          def transform(item, *ignore) 
            item.each_with_object({}) do |(k, v), new_item|
              if ignore && ignore.include?(k)
                new_item[k] = v
                next
              end
              new_key = (!protected?(k) && keyword?(k)) ? "#{k}.keyword" : k

              new_value = v
          
              if new_value.is_a?(Hash)
                new_value = transform(new_value)
              elsif new_value.is_a?(Array)
                new_value = new_value.map { |i| i.is_a?(Hash) ? transform(i) : i }
              elsif new_value.is_a?(String) || new_value.is_a?(Symbol) 
                new_value = "#{new_value}.keyword" if keyword?(new_value) && new_value.to_s !~ /\.keyword$/
              end

              new_item[new_key] = new_value
            end
          end

          # # If terms are used, we assume that the field is a keyword field
          # # and append .keyword to the field name
          # # {terms: {field: 'gender'}}
          # # or nested aggs
          # # {terms: {field: 'gender'}, aggs: {name: {terms: {field: 'position.name'}}}}
          # # should be converted to
          # # {terms: {field: 'gender.keyword'}, aggs: {name: {terms: {field: 'position.name.keyword'}}}}
          # # {date_histogram: {field: 'created_at', interval: 'day'}}
          # def assume_keyword_field(args={}, parent_match=false)
          #   if args.is_a?(Hash)
          #     args.each do |k, v|
          #       if v.is_a?(Hash) 
          #         assume_keyword_field(v, KEYWORD_AGGREGATION_FIELDS.include?(k))
          #       else
          #         next unless v.is_a?(String) || v.is_a?(Symbol)
          #         args[k] = ([:field, :fields].include?(k.to_sym) && v !~ /\.keyword$/ && parent_match) ? "#{v}.keyword" : v.to_s
          #       end
          #     end
          #   end
          # end

      end
    end
  end
end
