# Stretchy::Relations::QueryMethods::QueryString [](#module-Stretchy::Relations::QueryMethods::QueryString) [](#top)

    

# Public Instance Methods

      
## query_string(opts = :chain, *rest) [](#method-i-query_string)
         
Adds a query string to the search.

The query string uses Elasticsearch's Query String Query syntax, which includes a series of terms and operators.
Terms can be single words or phrases. Operators include AND, OR, and NOT, among others.
Field names can be included in the query string to search for specific values in specific fields. (e.g. "eye_color: green")
The default operator between terms are treated as OR operators.

### Parameters

- `opts:` The query string 

### Returns
Returns a new Stretchy::Relation, which reflects the query string.

---

### Examples

#### Query string

```ruby
  Model.query_string("((big cat) OR (domestic cat)) AND NOT panther eye_color: green")
```  
        
---

