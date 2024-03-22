# Stretchy::Attributes::Type::Histogram [](#class-Stretchy::Attributes::Type::Histogram) [](#top)
The Histogram attribute type

This class is used to define a histogram attribute for a model. It provides support for the Elasticsearch histogram data type, which is a type of data type that can hold arrays of values and counts.

### Parameters

- `type:` `:histogram`.
- `options:` The Hash of options for the attribute.
   - `:ignore_malformed:` The Boolean indicating if malformed numbers should be ignored. Defaults to false.
   - `:coerce:` The Boolean indicating if the field should automatically convert strings to numbers and truncate fractions for integers. Defaults to true.

---

### Examples

#### Define a histogram attribute

```ruby
  class MyModel < StretchyModel
    attribute :grades_distribution, :histogram, ignore_malformed: true
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

