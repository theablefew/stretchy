# class Stretchy::Attributes::Type::Shape [](#class-Stretchy::Attributes::Type::Shape) [](#top)
Defines a shape attribute for the model. This field type is used for complex shapes.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:orientation
</dt>
<dd>
<p>The String indicating how to interpret vertex order for polygons / multipolygons. Can be ‘right’, ‘ccw’, ‘counterclockwise’, ‘left’, ‘cw’, ‘clockwise’. Defaults to ‘ccw’.</p>
</dd>
<dt>:ignore_malformed
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if malformed GeoJSON or WKT shapes should be ignored. Defaults to false.</p>
</dd>
<dt>:ignore_z_value
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the z value of three dimension points should be ignored. Defaults to true.</p>
</dd>
<dt>:coerce
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if unclosed linear rings in polygons will be automatically closed. Defaults to false.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Shape-label-Examples) [↑](#top)

```
classMyModel\<Stretchy::Recordattribute:boundary,:shape,orientation:'cw'end
```

### Returns[¶](#class-Stretchy::Attributes::Type::Shape-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 