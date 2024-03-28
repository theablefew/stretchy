# module Stretchy::Relations::QueryMethods::Field [](#module-Stretchy::Relations::QueryMethods::Field) [](#top)
 ## Public Instance Methods
 ### field(*args) [](#method-i-field)
 Specify the fields to be returned by the [`Elasticsearch`](../../../Elasticsearch.html) query.

This method accepts a variable number of arguments, each of which is the name of a field to be returned. If no arguments are provided, all fields are returned.

To retrieve specific fields in the search response, use the fields parameter. Because it consults the index mappings, the fields parameter provides several advantages over referencing the `_source` directly. Specifically, the fields parameter: Returns each value in a standardized way that matches its mapping type Accepts multi-fields and field aliases Formats dates and spatial data types Retrieves runtime field values Returns fields calculated by a script at index time Returns fields from related indices using lookup runtime fields

### Parameters[¶](#method-i-field-label-Parameters) [↑](#top)

- `args:` The Array of field names to be returned by the query (default: []).

### Returns[¶](#method-i-field-label-Returns) [↑](#top)

Returns a new [`Stretchy::Relation`](../../Relation.html) with the specified fields to be returned.

* * *

### Examples[¶](#method-i-field-label-Examples) [↑](#top)

#### Single field[¶](#method-i-field-label-Single+field) [↑](#top)

```
Model.fields(:title)
```

#### Multiple fields[¶](#method-i-field-label-Multiple+fields) [↑](#top)

```
Model.fields(:title,:author)
```

#### Nested fields[¶](#method-i-field-label-Nested+fields) [↑](#top)

```
Model.fields('author.name','author.age')
```

#### Wildcard[¶](#method-i-field-label-Wildcard) [↑](#top)

```
Model.fields('books.\*')
```
 ### fields(*args) [](#method-i-fields)
 Alias for {#field} @see [`field`](Field.html#method-i-field)

 