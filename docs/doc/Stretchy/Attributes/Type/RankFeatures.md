# Stretchy::Attributes::Type::RankFeatures [](#class-Stretchy::Attributes::Type::RankFeatures) [](#top)
The RankFeatures attribute type

This class is used to define a rank_features attribute for a model. It provides support for the Elasticsearch rank_features data type, which is a type of data type that can index numeric feature vectors, so that they can later be used to boost documents in queries with a rank_feature query. It is better suited when the list of features is sparse so that it wouldn’t be reasonable to add one field to the mappings for each of them.

### Parameters

- `type:` `:rank_features`.
- `options:` The Hash of options for the attribute.
   - `:positive_score_impact:` The Boolean indicating if features correlate positively with the score. If set to false, the score decreases with the value of the feature instead of increasing. Defaults to true.

---

### Examples

#### Define a rank_features attribute

```ruby
  class MyModel < StretchyModel
    attribute :negative_reviews, :rank_features, positive_score_impact: false
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## mappings(name) [](#method-i-mappings)
         
  
        
---


## type() [](#method-i-type)
         
  
        
---


## type_for_database() [](#method-i-type_for_database)
         
  
        
---

