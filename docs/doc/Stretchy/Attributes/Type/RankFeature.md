# Stretchy::Attributes::Type::RankFeature [](#class-Stretchy::Attributes::Type::RankFeature) [](#top)
The RankFeature attribute type

This class is used to define a rank_feature attribute for a model. It provides support for the Elasticsearch rank_feature data type, which is a type of data type that can hold numerical features that should impact the relevance score of the documents.

### Parameters

- `type:` `:rank_feature`.
- `options:` The Hash of options for the attribute.
   - `:positive_score_impact:` The Boolean indicating if features correlate positively with the score. If set to false, the score decreases with the value of the feature instead of increasing. Defaults to true.

---

### Examples

#### Define a rank_feature attribute

```ruby
  class MyModel < StretchyModel
    attribute :url_length, :rank_feature, positive_score_impact: false
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

