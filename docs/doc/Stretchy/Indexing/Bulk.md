# module Stretchy::Indexing::Bulk [](#module-Stretchy::Indexing::Bulk) [](#top)
 ## Public Instance Methods
 ### bulk(records) [](#method-i-bulk)
 ### bulk_in_batches(records, size: 1000) { |batch| ... } [](#method-i-bulk_in_batches)
 [`bulk_in_batches`](Bulk.html#method-i-bulk_in_batches)(records, size: 100) do |batch| # do something with the batch batch.each { |record| record.to\_bulk(method)} end

 ### to_bulk(method = :index) [](#method-i-to_bulk)
 ### update_all(**attributes) [](#method-i-update_all)
 TODO: May only be needed for associations

 