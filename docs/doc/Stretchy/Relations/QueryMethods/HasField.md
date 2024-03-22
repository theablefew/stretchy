# Stretchy::Relations::QueryMethods::HasField [](#module-Stretchy::Relations::QueryMethods::HasField) [](#top)

    

# Public Instance Methods

      
## has_field(field) [](#method-i-has_field)
         
Checks if a field exists in the Elasticsearch document.

This method is used to filter the results of a query based on whether a field exists or not in the document.
It accepts a field name as an argument and adds an `exists` filter to the query.

### Parameters
- `field:` The Symbol or String representing the field name.

### Returns
Returns a new Stretchy::Relation with the `exists` filter applied.

---

### Examples

#### Has field
```ruby
  Model.has_field(:title)
```

#### Nested field exists
```ruby
  Model.has_field('author.name')
```  
        
---

