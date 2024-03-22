# Stretchy::Relations::QueryMethods::MustNot [](#module-Stretchy::Relations::QueryMethods::MustNot) [](#top)

    

# Public Instance Methods

      
## must_not(opts = :chain, *rest) [](#method-i-must_not)
_aliased as_ `where_not`
         
Adds negated conditions to the query.

Each argument is a keyword where the key is the attribute name and the value is the value to exclude.
This method acts as a convenience method for adding negated conditions to the query. It can also be used to add
range, regex, terms, and id queries through shorthand parameters.

### Parameters:
- `opts:` The keywords containing attribute-value pairs for conditions.

### Returns
Returns a new Stretchy::Relation with the specified conditions excluded.

---

### Examples

#### Exclude multiple conditions
```ruby
  Model.must_not(color: 'blue', size: :large)
```  
        
---


## where_not(opts = :chain, *rest) [](#method-i-where_not)
         
Alias for {#must_not}
@see #must_not  
        
---

