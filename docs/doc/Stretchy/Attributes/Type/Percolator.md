# class Stretchy::Attributes::Type::Percolator [](#class-Stretchy::Attributes::Type::Percolator) [](#top)
Defines a percolator attribute for the model.

The percolator field type parses a JSON structure into a native query and stores that query, so that the percolate query can use it to match provided documents.

Any field that contains a JSON object can be configured to be a percolator field. The percolator field type has no settings. Just configuring the percolator field type is sufficient to instruct Elasticsearch to treat a field as a query.

### Examples[¶](#class-Stretchy::Attributes::Type::Percolator-label-Examples) [↑](#top)

```
classMyModel\<StretchyModelattribute:query,:percolatorend
```

### Returns[¶](#class-Stretchy::Attributes::Type::Percolator-label-Returns) [↑](#top)

Returns nothing.

 ## Public Instance Methods
 ### type() [](#method-i-type)
 