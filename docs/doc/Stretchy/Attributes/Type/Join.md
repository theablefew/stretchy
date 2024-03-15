# class Stretchy::Attributes::Type::Join [](#class-Stretchy::Attributes::Type::Join) [](#top)
Defines a join attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to define the parent/child relation within documents of the same index (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:relations
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> defining a set of possible relations within the documents, each relation being a parent name and a child name.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Join-label-Examples) [↑](#top)

```
classMyModelincludeStretchyModelattribute:relation,:join,relations:{question::answer}end
```

### Returns[¶](#class-Stretchy::Attributes::Type::Join-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 