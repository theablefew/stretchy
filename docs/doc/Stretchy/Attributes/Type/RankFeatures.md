# class Stretchy::Attributes::Type::RankFeatures [](#class-Stretchy::Attributes::Type::RankFeatures) [](#top)
It is analogous to the rank\_feature data type but is better suited when the list of features is sparse so that it wouldn’t be reasonable to add one field to the mappings for each of them.

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
### Examples[¶](#class-Stretchy::Attributes::Type::RankFeatures-label-Examples) [↑](#top)

```
classMyModel\<StretchyModelattribute:negative\_reviews,:rank\_features,positive\_score\_impact:falseend
```

### Returns[¶](#class-Stretchy::Attributes::Type::RankFeatures-label-Returns) [↑](#top)

Returns nothing.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **OPTIONS[](#OPTIONS)** | Not documented |
 ## Public Instance Methods
 ### type() [](#method-i-type)
 