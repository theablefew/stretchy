# Stretchy::Relations::AggregationMethods::SignificantTerms [](#module-Stretchy::Relations::AggregationMethods::SignificantTerms) [](#top)

    

# Public Instance Methods

      
## significant_terms(name, options = {}, *aggs) [](#method-i-significant_terms)
         
Perform a significant_terms aggregation.

This method is used to perform a significant_terms aggregation, which allows you to find the terms that are unusually common in your data set compared to a background data set. It accepts a name for the aggregation, a hash of options for the aggregation, and an optional array of nested aggregations.

### Parameters

- `name:` The Symbol or String representing the name of the aggregation.
- `options:` The Hash representing the options for the aggregation (default: {}).
    - `:field:` The String representing the field to use for the significant_terms aggregation.
    - `:background_filter:` The Hash representing the background filter to use for the significant_terms aggregation.
    - `:mutual_information:` The Hash representing the mutual information to use for the significant_terms aggregation.
    - `:chi_square:` The Hash representing the chi square to use for the significant_terms aggregation.
    - `:gnd:` The Hash representing the gnd to use for the significant_terms aggregation.
    - `:jlh:` The Hash representing the jlh to use for the significant_terms aggregation.
- `aggs:` The Array of Hashes representing nested aggregations (optional).

### Returns
Returns a new Stretchy::Relation with the specified significant_terms aggregation.

---

### Examples

#### Significant_terms aggregation

```ruby
  Model.significant_terms(:my_agg, {field: 'field_name'})
  Model.significant_terms(:my_agg, {field: 'field_name'}, aggs: {...})
```  
        
---

