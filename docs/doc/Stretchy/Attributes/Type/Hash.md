# class Stretchy::Attributes::Type::Hash [](#class-Stretchy::Attributes::Type::Hash) [](#top)
Defines a hash attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:dynamic
</dt>
<dd>
<p>The String indicating if new properties should be added dynamically to an existing object. Can be ‘true’, ‘runtime’, ‘false’, or ‘strict’. Defaults to ‘true’.</p>
</dd>
<dt>:enabled
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the JSON value for the object field should be parsed and indexed. Defaults to true.</p>
</dd>
<dt>:subobjects
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the object can hold subobjects. Defaults to true.</p>
</dd>
<dt>:properties
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> of fields within the object, which can be of any data type, including object.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Hash-label-Examples) [↑](#top)

```
classMyModel\<Stretchy::Recordattribute:metadata,:hash,dynamic:'strict',subobjects:falseend
```

### Returns[¶](#class-Stretchy::Attributes::Type::Hash-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 