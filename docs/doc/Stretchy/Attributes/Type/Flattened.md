# class Stretchy::Attributes::Type::Flattened [](#class-Stretchy::Attributes::Type::Flattened) [](#top)
Defines a flattened attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:depth_limit
</dt>
<dd>
<p>The Integer maximum allowed depth of the flattened object field. Defaults to 20.</p>
</dd>
<dt>:doc_values
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.</p>
</dd>
<dt>:eager_global_ordinals
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if global ordinals should be loaded eagerly on refresh. Defaults to false.</p>
</dd>
<dt>:ignore_above
</dt>
<dd>
<p>The Integer limit for the length of leaf values. Values longer than this limit will not be indexed. By default, there is no limit.</p>
</dd>
<dt>:index
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be searchable. Defaults to true.</p>
</dd>
<dt>:index_options
</dt>
<dd>
<p>The String indicating what information should be stored in the index for scoring purposes. Defaults to ‘docs’.</p>
</dd>
<dt>:null_value
</dt>
<dd>
<p>The String value to be substituted for any explicit null values. Defaults to null.</p>
</dd>
<dt>:similarity
</dt>
<dd>
<p>The String scoring algorithm or similarity to be used. Defaults to ‘BM25’.</p>
</dd>
<dt>:split_queries_on_whitespace
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if full text queries should split the input on whitespace. Defaults to false.</p>
</dd>
<dt>:time_series_dimensions
</dt>
<dd>
<p>The Array of Strings indicating the fields inside the flattened object that are dimensions of the time series.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Flattened-label-Examples) [↑](#top)

```
classMyModelincludeStretchyModelattribute:metadata,:flattened,depth\_limit:10,index\_options:'freqs'end
```

### Returns[¶](#class-Stretchy::Attributes::Type::Flattened-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 