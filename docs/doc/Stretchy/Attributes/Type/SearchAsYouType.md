# Stretchy::Attributes::Type::SearchAsYouType [](#class-Stretchy::Attributes::Type::SearchAsYouType) [](#top)
The SearchAsYouType attribute type

This class is used to define a search_as_you_type attribute for a model. This field type is optimized to provide out-of-the-box support for queries that serve an as-you-type completion use case.

### Parameters

- `type:` `:search_as_you_type`.
- `options:` The Hash of options for the attribute.
   - `:max_shingle_size:` The Integer indicating the largest shingle size to create. Valid values are 2 to 4. Defaults to 3.
   - `:analyzer:` The String analyzer to be used for text fields, both at index-time and at search-time. Defaults to the default index analyzer, or the standard analyzer.
   - `:index:` The Boolean indicating if the field should be searchable. Defaults to true.
   - `:index_options:` The String indicating what information should be stored in the index, for search and highlighting purposes. Defaults to 'positions'.
   - `:norms:` The Boolean indicating if field-length should be taken into account when scoring queries. Defaults to true.
   - `:store:` The Boolean indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.
   - `:search_analyzer:` The String analyzer that should be used at search time on text fields. Defaults to the analyzer setting.
   - `:search_quote_analyzer:` The String analyzer that should be used at search time when a phrase is encountered. Defaults to the search_analyzer setting.
   - `:similarity:` The String indicating which scoring algorithm or similarity should be used. Defaults to 'BM25'.
   - `:term_vector:` The String indicating if term vectors should be stored for the field. Defaults to 'no'.

---

### Examples

#### Define a search_as_you_type attribute

```ruby
  class MyModel < StretchyModel
    attribute :name, :search_as_you_type, max_shingle_size: 4
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

