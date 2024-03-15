# class Stretchy::Attributes::Type::Completion [](#class-Stretchy::Attributes::Type::Completion) [](#top)
Defines a completion attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:analyzer
</dt>
<dd>
<p>The String index analyzer to use. Defaults to ‘simple’.</p>
</dd>
<dt>:search_analyzer
</dt>
<dd>
<p>The String search analyzer to use. Defaults to the value of :analyzer.</p>
</dd>
<dt>:preserve_separators
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if separators should be preserved. Defaults to true.</p>
</dd>
<dt>:preserve_position_increments
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if position increments should be enabled. Defaults to true.</p>
</dd>
<dt>:max_input_length
</dt>
<dd>
<p>The Integer limit for the length of a single input. Defaults to 50.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::Completion-label-Examples) [↑](#top)

```
classMyModel\<Stretchy::Recordattribute:name,:completion,analyzer:'simple',max\_input\_length:100end
```

### Returns[¶](#class-Stretchy::Attributes::Type::Completion-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 