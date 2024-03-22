# Stretchy::Relations::QueryMethods::Should [](#module-Stretchy::Relations::QueryMethods::Should) [](#top)

    

# Public Instance Methods

      
## should(opts = :chain, *rest) [](#method-i-should)
         
Adds optional conditions to the query.

Each argument is a hash where the key is the attribute to filter by and the value is the value to match optionally.

### Parameters

- `opts:` The Hash representing the attribute-value pairs to match optionally or a Symbol `:chain` to return a new WhereChain.

### Returns
Returns a new Stretchy::Relation, which reflects the optional conditions.

---

### Examples

#### Optional conditions

```ruby
  Model.should(color: :pink, size: :medium)
```  
        
---

