# Stretchy::Relations::QueryMethods::Source [](#module-Stretchy::Relations::QueryMethods::Source) [](#top)

    

# Public Instance Methods

      
## source(*args) [](#method-i-source)
         
Controls which fields of the source are returned.

This method supports source filtering, which allows you to include or exclude fields from the source.
You can specify fields directly, use wildcard patterns, or use an object containing arrays
of includes and excludes patterns.

If the includes property is specified, only source fields that match one of its patterns are returned.
You can exclude fields from this subset using the excludes property.

If the includes property is not specified, the entire document source is returned, excluding any
fields that match a pattern in the excludes property.

### Parameters
  - `:includes:` The Array of fields to be included in the source (default: []).
  - `:excludes:` The Array of fields to be excluded from the source (default: []).
  - Or a Boolean indicating whether to include the source.

### Returns
Returns a Stretchy::Relation, which reflects the source filtering.

---

### Examples

#### Include source
```ruby
  Model.source(includes: [:name, :email])
```

#### Exclude source
```ruby
  Model.source(excludes: [:name, :email])
```

#### No source
```ruby
  Model.source(false) # don't include source
```  
        
---

