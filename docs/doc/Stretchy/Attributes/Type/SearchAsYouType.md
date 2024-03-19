# class Stretchy::Attributes::Type::SearchAsYouType [](#class-Stretchy::Attributes::Type::SearchAsYouType) [](#top)
Defines a search\_as\_you\_type attribute for the model. This field type is optimized to provide out-of-the-box support for queries that serve an as-you-type completion use case.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:max_shingle_size
</dt>
<dd>
<p>The Integer indicating the largest shingle size to create. Valid values are 2 to 4. Defaults to 3.</p>
</dd>
<dt>:analyzer
</dt>
<dd>
<p>The String analyzer to be used for text fields, both at index-time and at search-time. Defaults to the default index analyzer, or the standard analyzer.</p>
</dd>
<dt>:index
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be searchable. Defaults to true.</p>
</dd>
<dt>:index_options
</dt>
<dd>
<p>The String indicating what information should be stored in the index, for search and highlighting purposes. Defaults to ‘positions’.</p>
</dd>
<dt>:norms
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if field-length should be taken into account when scoring queries. Defaults to true.</p>
</dd>
<dt>:store
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.</p>
</dd>
<dt>:search_analyzer
</dt>
<dd>
<p>The String analyzer that should be used at search time on text fields. Defaults to the analyzer setting.</p>
</dd>
<dt>:search_quote_analyzer
</dt>
<dd>
<p>The String analyzer that should be used at search time when a phrase is encountered. Defaults to the search_analyzer setting.</p>
</dd>
<dt>:similarity
</dt>
<dd>
<p>The String indicating which scoring algorithm or similarity should be used. Defaults to ‘BM25’.</p>
</dd>
<dt>:term_vector
</dt>
<dd>
<p>The String indicating if term vectors should be stored for the field. Defaults to ‘no’.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::SearchAsYouType-label-Examples) [↑](#top)

```
classMyModel\<StretchyModelattribute:name,:search\_as\_you\_type,max\_shingle\_size:4end
```

### Returns[¶](#class-Stretchy::Attributes::Type::SearchAsYouType-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 