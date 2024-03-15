# class Stretchy::Attributes::Type::GeoShape [](#class-Stretchy::Attributes::Type::GeoShape) [](#top)
Defines a geo\_shape attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:orientation
</dt>
<dd>
<p>The String default orientation for the field’s WKT polygons. Can be ‘right’, ‘counterclockwise’, ‘ccw’, ‘left’, ‘clockwise’, or ‘cw’. Defaults to ‘right’.</p>
</dd>
<dt>:ignore_malformed
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if malformed GeoJSON or WKT shapes should be ignored. Defaults to false.</p>
</dd>
<dt>:ignore_z_value
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if three dimension points should be accepted but only latitude and longitude values should be indexed. Defaults to true.</p>
</dd>
<dt>:coerce
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if unclosed linear rings in polygons should be automatically closed. Defaults to false.</p>
</dd>
<dt>:index
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be quickly searchable. Defaults to true.</p>
</dd>
<dt>:doc_values
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the field should be stored on disk in a column-stride fashion. Defaults to true.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::GeoShape-label-Examples) [↑](#top)

```
classMyModelincludeStretchyModelattribute:boundary,:geo\_shape,orientation:'left',coerce:trueend
```

### Returns[¶](#class-Stretchy::Attributes::Type::GeoShape-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 