# Stretchy::Attributes::Transformers::KeywordTransformer [](#class-Stretchy::Attributes::Transformers::KeywordTransformer) [](#top)
Applies transformations to keyword fields in queries

### Examples

```ruby
class Goat < StretchyModel
 attribute :name, :keyword
 attribute :age, :integer
end

Goat.where(name: 'billy').to_elastic
# => {query: {term: {'name.keyword': 'billy'}}}

```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **KEYWORD_AGGREGATION_KEYS[](#KEYWORD_AGGREGATION_KEYS)** | Not Documented |

### Attributes

#### attribute_types[R] [](#attribute-i-attribute_types)
 
 

---


# Public Class Methods

      
## new(attribute_types) [](#method-c-new)
         
  
        
---


# Public Instance Methods

      
## cast_value_keys() [](#method-i-cast_value_keys)
         
  
        
---


## keyword_available?(arg) [](#method-i-keyword_available-3F)
         
  
        
---


## keyword_field_for(arg) [](#method-i-keyword_field_for)
         
  
        
---


## protected?(arg) [](#method-i-protected-3F)
         
  
        
---


## transform(item, *ignore) [](#method-i-transform)
         
Add `.keyword` to attributes that have a keyword subfield but aren't `:keywords`
this is for text fields that have a keyword subfield
`:text` and `:string` fields add a `:keyword` subfield to the attribute mapping automatically  
        
---

