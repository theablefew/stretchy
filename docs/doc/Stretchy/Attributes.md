# Stretchy::Attributes [](#module-Stretchy::Attributes) [](#top)
used to define and manage the attributes of a model in Stretchy. It provides methods for getting and setting attribute values, inspecting the model, and registering attribute types.

### Methods

- `[](attribute)`: Retrieves the value of the specified attribute.
- `[]=(attribute, value)`: Sets the value of the specified attribute.
- `inspect`: Returns a string representation of the model, including its class name and attributes.
- `self.inspect`: Returns a string representation of the model class, including its name and attribute types.
- `attribute_mappings`: Returns a JSON representation of the attribute mappings for the model.
- `self.register!`: Registers the attribute types with ActiveModel.

### Example

In this example, the `Attributes` module is used to define an attribute for `MyModel`, get and set the attribute value, inspect the model and the model class, and get the attribute mappings.

```ruby
class MyModel < Stretchy::Record
  attribute :title, :string
end

model = MyModel.new(title: "hello")
model[:title] # => "hello"
model.inspect # => "#<MyModel title: hello>"
MyModel.inspect # => "#<MyModel title: string>"
MyModel.attribute_mappings # => {properties: {title: {type: "string"}}}
```
---
---
---
---
---
---
    

# Public Class Methods

      
## register!() [](#method-c-register-21)
         
  
        
---


# Public Instance Methods

      
## [](attribute) [](#method-i-5B-5D)
         
  
        
---


## []=(attribute, value) [](#method-i-5B-5D-3D)
         
  
        
---


## attribute_mappings() [](#method-i-attribute_mappings)
         
  
        
---


## inspect() [](#method-i-inspect)
         
  
        
---

