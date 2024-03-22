# Stretchy::Attributes::Type::Numeric::HalfFloat [](#class-Stretchy::Attributes::Type::Numeric::HalfFloat) [](#top)
The HalfFloat attribute type

This class is used to define a half_float attribute for a model. It provides support for the Elasticsearch numeric data type, which is a type of data type that can hold half-precision 16-bit IEEE 754 floating point values.

### Parameters

- `type:` `:half_float`.

---

### Examples

#### Define a half_float attribute

```ruby
  class MyModel < StretchyModel
    attribute :rating, :half_float
  end
```
    

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

