# Stretchy::Relations::QueryMethods::Fields [](#module-Stretchy::Relations::QueryMethods::Fields) [](#top)

    

# Public Instance Methods

      
## field(*args) [](#method-i-field)
         
Alias for {#field}
@see #field  
        
---


## fields(*args) [](#method-i-fields)
_aliased as_ `field`
         
Specify the fields to be returned by the Elasticsearch query.

This method accepts a variable number of arguments, each of which is the name of a field to be returned.
If no arguments are provided, all fields are returned.

To retrieve specific fields in the search response, use the fields parameter. 
Because it consults the index mappings, the fields parameter provides several advantages over referencing 
the `_source` directly. Specifically, the fields parameter:
  Returns each value in a standardized way that matches its mapping type
  Accepts multi-fields and field aliases
  Formats dates and spatial data types
  Retrieves runtime field values
  Returns fields calculated by a script at index time
  Returns fields from related indices using lookup runtime fields

### Parameters
- `args:` The Array of field names to be returned by the query (default: []).

### Returns
Returns a new Stretchy::Relation with the specified fields to be returned.

---

### Examples

#### Single field
```ruby
  Model.fields(:title)
```

#### Multiple fields
```ruby
  Model.fields(:title, :author)
```

#### Nested fields
```ruby
  Model.fields('author.name', 'author.age')
```

#### Wildcard
```ruby
  Model.fields('books.*')
```  
        
---

