# class Stretchy::Attributes::Transformers::KeywordTransformer [](#class-Stretchy::Attributes::Transformers::KeywordTransformer) [](#top)
 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **KEYWORD_AGGREGATION_KEYS[](#KEYWORD_AGGREGATION_KEYS)** | Not documented |
 ## Attributes
 ### attribute_types[R] [](#attribute-i-attribute_types)
 ## Public Class Methods
 ### new(attribute_types) [](#method-c-new)
 ## Public Instance Methods
 ### assume_keyword_field(args={}, parent_match=false) [](#method-i-assume_keyword_field)
 If terms are used, we assume that the field is a keyword field and append .keyword to the field name {terms: {field: ‘gender’}} or nested aggs {terms: {field: ‘gender’}, aggs: {name: {terms: {field: ‘position.name’}}}} should be converted to {terms: {field: ‘gender.keyword’}, aggs: {name: {terms: {field: ‘position.name.keyword’}}}} {date\_histogram: {field: ‘created\_at’, interval: ‘day’}} TODO: There may be cases where we don’t want to add .keyword to the field and there should be a way to override this

 ### cast_value_keys() [](#method-i-cast_value_keys)
 ### keyword?(arg) [](#method-i-keyword-3F)
 ### protected?(arg) [](#method-i-protected-3F)
 ### transform(item, *ignore) [](#method-i-transform)
 