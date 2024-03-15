# class Stretchy::Attributes::Type::Nested [](#class-Stretchy::Attributes::Type::Nested) [](#top)
Defines a nested attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:dynamic
</dt>
<dd>
<p>The String indicating if new properties should be added dynamically to an existing nested object. Can be ‘true’, ‘false’, or ‘strict’. Defaults to ‘true’.</p>
</dd>
<dt>:properties
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> of fields within the nested object, which can be of any data type, including nested.</p>
</dd>
<dt>:include_in_parent
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if all fields in the nested object are also added to the parent document as standard fields. Defaults to false.</p>
</dd>
<dt>:include_in_root
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if all fields in the nested object are also added to the root document as standard fields. Defaults to false.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Nested-label-Examples) [↑](#top)

```
classMyModelincludeStretchyModelattribute:metadata,:nested,dynamic:'strict',include\_in\_parent:trueend
```

### Returns[¶](#class-Stretchy::Attributes::Type::Nested-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 