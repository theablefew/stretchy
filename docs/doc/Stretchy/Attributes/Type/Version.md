# Stretchy::Attributes::Type::Version [](#class-Stretchy::Attributes::Type::Version) [](#top)
The Version attribute type

This class is used to define a version attribute for a model. This field type is used for software versions following the Semantic Versioning rules.

### Parameters

- `type:` `:version`.
- `options:` The Hash of options for the attribute.
   - `:meta:` The Hash of metadata about the field.

---

### Examples

#### Define a version attribute

```ruby
  class MyModel < StretchyModel
    attribute :software_version, :version
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

