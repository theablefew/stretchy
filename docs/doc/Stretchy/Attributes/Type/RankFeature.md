# class Stretchy::Attributes::Type::RankFeature [](#class-Stretchy::Attributes::Type::RankFeature) [](#top)
Defines a rank\_feature attribute for the model.

<dl class="rdoc-list note-list">
<dt>opts
</dt>
<dd>
<p>The <a href="Hash.html"><code>Hash</code></a> options used to refine the attribute (default: {}):</p>
<dl class="rdoc-list note-list">
<dt>:positive_score_impact
</dt>
<dd>
<p>The <a href="Boolean.html"><code>Boolean</code></a> indicating if features correlate positively with the score. If set to false, the score decreases with the value of the feature instead of increasing. Defaults to true.</p>
</dd>
</dl>
</dd>
</dl>
### Examples[¶](#class-Stretchy::Attributes::Type::RankFeature-label-Examples) [↑](#top)

```
classMyModel\<StretchyModelattribute:url\_length,:rank\_feature,positive\_score\_impact:falseend
```

### Returns[¶](#class-Stretchy::Attributes::Type::RankFeature-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 