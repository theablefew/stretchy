# class Stretchy::Attributes::Type::TokenCount [](#class-Stretchy::Attributes::Type::TokenCount) [](#top)
Defines a token\_count attribute for the model. This field type is used for counting the number of tokens in a string.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:analyzer
</dt>
<dd>
<p>The String analyzer to be used to analyze the string value. Required.</p>
</dd>
<dt>:enable_position_increments
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if position increments should be counted. Defaults to true.</p>
</dd>
<dt>:doc_values
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.</p>
</dd>
<dt>:index
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be searchable. Defaults to true.</p>
</dd>
<dt>:null_value
</dt>
<dd>
<p>The <a href="Numeric.html"><code>Numeric</code></a> value to be substituted for any explicit null values. Defaults to null.</p>
</dd>
<dt>:store
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field value should be stored and retrievable separately from the _source field. Defaults to false.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::TokenCount-label-Examples) [↑](#top)

```
classMyModel\<StretchyModelattribute:description\_token\_count,:token\_count,analyzer:'standard'end
```

### Returns[¶](#class-Stretchy::Attributes::Type::TokenCount-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 