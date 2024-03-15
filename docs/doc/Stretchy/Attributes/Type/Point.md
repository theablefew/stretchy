# class Stretchy::Attributes::Type::Point [](#class-Stretchy::Attributes::Type::Point) [](#top)
Defines a point attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:ignore_malformed
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if malformed points should be ignored. Defaults to false.</p>
</dd>
<dt>:ignore_z_value
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if the z value of three dimension points should be ignored. Defaults to true.</p>
</dd>
<dt>:null_value
</dt>
<dd>
<p>The <a href="Point.html"><code>Point</code></a> value to be substituted for any explicit null values. Defaults to null.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Point-label-Examples) [↑](#top)

```
classMyModelincludeStretchyModelattribute:location,:point,ignore\_malformed:trueend
```

### Returns[¶](#class-Stretchy::Attributes::Type::Point-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 