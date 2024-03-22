# Stretchy::SharedScopes [](#module-Stretchy::SharedScopes) [](#top)

    

# Public Instance Methods

      
## time_based_indices(range, format = "%Y_%m") [](#method-i-time_based_indices)
         
Helpful when you want to search across multiple indices when there are 
many indices for a given model. It significantly reduces the load on the cluster. 

@example Narrow search across indices for the last 2 months

    class Twitter < Stretchy::Model
       scope :monthly_indices, lambda { |range| search_options(index: time_based_indices(range)) }
    end 

    Twitter.monthly_indices(2.months.ago..1.day.ago)
    => search_url:  "/twitter_2024_01*,twitter_2024_02*,twitter_2024_03*/_search"   
        
---

