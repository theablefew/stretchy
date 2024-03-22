# Stretchy::Relations::QueryMethods::SkipCallbacks [](#module-Stretchy::Relations::QueryMethods::SkipCallbacks) [](#top)

    

# Public Instance Methods

      
## skip_callbacks(*args) [](#method-i-skip_callbacks)
         
Allows you to skip callbacks for the specified fields.

This method is used to skip callbacks that are added by `query_must_have` for the specified fields for the current query. It accepts a variable number of arguments, each of which is the name of a field to skip callbacks for.

### Parameters

- `args:` The Array of field names to skip callbacks for.

### Returns
Returns a new Stretchy::Relation with the specified fields to skip callbacks for.

---

### Examples

#### Skip callbacks for a single field

```ruby
  Model.skip_callbacks(:routing)
```

#### Skip callbacks for multiple fields

```ruby
  Model.skip_callbacks(:routing, :relevance)
```  
        
---

