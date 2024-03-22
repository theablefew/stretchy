# Stretchy::Relations::SpawnMethods [](#module-Stretchy::Relations::SpawnMethods) [](#top)

    

# Public Instance Methods

      
## except(*skips) [](#method-i-except)
         
Removes from the query the condition(s) specified in +skips+.

  Post.order('id asc').except(:order)                  # discards the order condition
  Post.where('id > 10').order('id asc').except(:where) # discards the where condition but keeps the order  
        
---


## merge(other) [](#method-i-merge)
         
  
        
---


## only(*onlies) [](#method-i-only)
         
Removes any condition from the query other than the one(s) specified in +onlies+.

  Post.order('id asc').only(:where)         # discards the order condition
  Post.order('id asc').only(:where, :order) # uses the specified order  
        
---


## spawn() [](#method-i-spawn)
         
  
        
---

