# Stretchy::Relations::QueryMethods::FilterQuery [](#module-Stretchy::Relations::QueryMethods::FilterQuery) [](#top)

    

# Public Instance Methods

      
## filter_query(name, options = {}, &block) [](#method-i-filter_query)
         
Adds a filter to the Elasticsearch query.

This method is used to filter the results of a query without affecting the score. It accepts a type and a condition.
The type can be any valid Elasticsearch filter type, such as `:term`, `:range`, or `:bool`. The condition is a hash
that specifies the filter conditions.

### Parameters
- `type:` The Symbol representing the filter type.
- `condition:` The Hash containing the filter conditions.

### Returns
Returns a new Stretchy::Relation with the specified filter applied.

---

### Examples

#### Term filter
```ruby
  Model.filter_query(:term, color: 'blue')
```

#### Range filter
```ruby
  Model.filter_query(:range, age: { gte: 21 })
```

#### Bool filter
```ruby
  Model.filter_query(:bool, must: [{ term: { color: 'blue' } }, { range: { age: { gte: 21 } } }])
```  
        
---

