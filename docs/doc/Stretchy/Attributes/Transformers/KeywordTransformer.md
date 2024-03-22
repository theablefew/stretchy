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

      
## assume_keyword_field(args={}, parent_match=false) [](#method-i-assume_keyword_field)
         
If terms are used, we assume that the field is a keyword field
and append .keyword to the field name
{terms: {field: 'gender'}}
or nested aggs
{terms: {field: 'gender'}, aggs: {name: {terms: {field: 'position.name'}}}}
should be converted to
{terms: {field: 'gender.keyword'}, aggs: {name: {terms: {field: 'position.name.keyword'}}}}
{date_histogram: {field: 'created_at', interval: 'day'}}  
        
---


## cast_value_keys() [](#method-i-cast_value_keys)
         
  
        
---


## keyword?(arg) [](#method-i-keyword-3F)
         
  
        
---


## protected?(arg) [](#method-i-protected-3F)
         
  
        
---


## transform(item, *ignore) [](#method-i-transform)
         
  
        
---

