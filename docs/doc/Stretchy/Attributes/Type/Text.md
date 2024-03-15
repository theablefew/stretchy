# class Stretchy::Attributes::Type::Text [](#class-Stretchy::Attributes::Type::Text) [](#top)
Defines a text attribute for the model. This field type is used for text strings.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:analyzer
</dt>
<dd>
<p>The String analyzer to be used for the text field, both at index-time and at search-time. Defaults to the default index analyzer, or the standard analyzer.</p>
</dd>
<dt>:eager_global_ordinals
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if global ordinals should be loaded eagerly on refresh. Defaults to false.</p>
</dd>
<dt>:fielddata
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field can use in-memory fielddata for sorting, aggregations, or scripting. Defaults to false.</p>
</dd>
<dt>:fielddata_frequency_filter
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> of expert settings which allow to decide which values to load in memory when fielddata is enabled.</p>
</dd>
<dt>:fields
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> of multi-fields allow the same string value to be indexed in multiple ways for different purposes. By default, a ‘keyword’ field is added. Set to false to disable.</p>
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
<dt>:index_prefixes
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> indicating if term prefixes of between 2 and 5 characters are indexed into a separate field.</p>
</dd>
<dt>:index_phrases
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if two-term word combinations (shingles) are indexed into a separate field. Defaults to false.</p>
</dd>
<dt>:norms
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if field-length should be taken into account when scoring queries. Defaults to true.</p>
</dd>
<dt>:position_increment_gap
</dt>
<dd>
<p>The Integer indicating the number of fake term position which should be inserted between each element of an array of strings. Defaults to 100.</p>
</dd>
<dt>:store
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.</p>
</dd>
<dt>:search_analyzer
</dt>
<dd>
<p>The String analyzer that should be used at search time on the text field. Defaults to the analyzer setting.</p>
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
<dt>:meta
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> of metadata about the field.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Text-label-Examples) [↑](#top)

```
classMyModelincludeStretchyModelattribute:description,:text,analyzer:'english'end
```

### Returns[¶](#class-Stretchy::Attributes::Type::Text-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### mappings(name) [](#method-i-mappings)
 ### type() [](#method-i-type)
 ### type_for_database() [](#method-i-type_for_database)
 