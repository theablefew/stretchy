# module Stretchy::Relations::FinderMethods [](#module-Stretchy::Relations::FinderMethods) [](#top)
 ## Public Instance Methods
 ### count() [](#method-i-count)
 size is not permitted to the count API but queries are.

if a query is supplied with ‘.count` then the user wants a count of the results matching the query

however, the default\_size is used to limit the number of results returned so we remove the size from the query and then call ‘.count` API

but if the user supplies a limit, then we should assume they want a count of the results which could lead to some confusion suppose the user calls ‘.size(100).count` and the default\_size is 100 if we remove size from the query, then the count could be greater than 100

I think the best way to handle this is to remove the size from the query only if it was applied by the default\_size If the user supplies a limit, then we should assume they want a count of the results

if size is called with a limit,

 ### count!() [](#method-i-count-21)
 ### first() [](#method-i-first)
 ### first!() [](#method-i-first-21)
 ### last() [](#method-i-last)
 ### last!() [](#method-i-last-21)
 