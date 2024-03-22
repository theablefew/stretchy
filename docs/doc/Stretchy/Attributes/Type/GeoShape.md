# Stretchy::Attributes::Type::GeoShape [](#class-Stretchy::Attributes::Type::GeoShape) [](#top)
The GeoShape attribute type

This class is used to define a geo_shape attribute for a model. It provides support for the Elasticsearch geo_shape data type, which is a type of data type that can hold geographical shapes.

### Parameters

- `type:` `:geo_shape`.
- `options:` The Hash of options for the attribute.
   - `:orientation:` The String default orientation for the field’s WKT polygons. Can be 'right', 'counterclockwise', 'ccw', 'left', 'clockwise', or 'cw'. Defaults to 'right'.
   - `:ignore_malformed:` The Boolean indicating if malformed GeoJSON or WKT shapes should be ignored. Defaults to false.
   - `:ignore_z_value:` The Boolean indicating if three dimension points should be accepted but only latitude and longitude values should be indexed. Defaults to true.
   - `:coerce:` The Boolean indicating if unclosed linear rings in polygons should be automatically closed. Defaults to false.
   - `:index:` The Boolean indicating if the field should be quickly searchable. Defaults to true.
   - `:doc_values:` The Boolean indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.

---

### Examples

#### Define a geo_shape attribute

```ruby
  class MyModel < StretchyModel
    attribute :boundary, :geo_shape, orientation: 'left', coerce: true
  end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **OPTIONS[](#OPTIONS)** | Not Documented |

# Public Instance Methods

      
## type() [](#method-i-type)
         
  
        
---

