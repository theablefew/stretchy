# Stretchy::Relations::QueryMethods::Ids [](#module-Stretchy::Relations::QueryMethods::Ids) [](#top)

    

# Public Instance Methods

      
## ids(*args) [](#method-i-ids)
         
Filters documents that only have the provided ids.

This method is used to filter the results of a query based on document ids. It accepts an array of ids.

### Parameters

- `args:` The Array of ids to be matched by the query.

### Returns
Returns a new Stretchy::Relation with the specified ids to be matched.

---

### Examples

#### Filter by ids

```ruby
  Model.ids([1, 2, 3])
```  
        
---

