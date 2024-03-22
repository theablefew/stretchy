# Stretchy::Relations::QueryMethods::Where [](#module-Stretchy::Relations::QueryMethods::Where) [](#top)

    

# Public Instance Methods

      
## must(opts = :chain, *rest) [](#method-i-must)
         
Alias for {#where}
@see #where  
        
---


## where(opts = :chain, *rest) [](#method-i-where)
_aliased as_ `must`
         
Adds conditions to the query.

Each argument is a keyword where the key is the attribute name and the value is the value to match.
This method acts as a convenience method for adding conditions to the query. It can also be used to add
range, regex, terms, and id queries through shorthand parameters.

### Parameters
- `opts:` The keywords containing attribute-value pairs for conditions.

### Returns
Returns a Stretchy::Relation with the specified conditions applied.

---

### Examples

#### Multiple Conditions
```ruby
  Model.where(price: 10, color: :green)
```

#### Range
```ruby
  Model.where(price: {gte: 10, lte: 20})
```

```ruby
  Model.where(age: 19..33)
```

#### Regular Expressions
```ruby
  Model.where(color: /gr(a|e)y/)
```

#### IDs
```ruby
  Model.where(id: [10, 22, 18])
```

#### Terms
```ruby
  Model.where(names: ['John', 'Jane'])
```  
        
---

