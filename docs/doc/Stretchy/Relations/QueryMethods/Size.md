# Stretchy::Relations::QueryMethods::Size [](#module-Stretchy::Relations::QueryMethods::Size) [](#top)

    

# Public Instance Methods

      
## limit(args) [](#method-i-limit)
         
Alias for {#size}
@see #size  
        
---


## size(args) [](#method-i-size)
_aliased as_ `limit`
         
Sets the maximum number of records to be retrieved.

This method is used to limit the number of records returned by the query. It accepts an integer as an argument.

### Parameters

- `args:` The Integer representing the maximum number of records to retrieve.

### Returns
Returns a new Stretchy::Relation, which reflects the limit.

---

### Examples

#### Limit the number of records

```ruby
  Model.size(10)
```  
        
---

