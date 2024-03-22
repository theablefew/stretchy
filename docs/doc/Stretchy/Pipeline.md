# Stretchy::Pipeline [](#class-Stretchy::Pipeline) [](#top)

    

### Attributes

#### description[RW] [](#attribute-c-description)
 
 

#### pipeline_name[RW] [](#attribute-c-pipeline_name)
 
 

#### processors[RW] [](#attribute-c-processors)
 
 

#### description[RW] [](#attribute-i-description)
 
 

#### pipeline_name[RW] [](#attribute-i-pipeline_name)
 
 

#### processors[RW] [](#attribute-i-processors)
 
 

---


# Public Class Methods

      
## all() [](#method-c-all)
         
  
        
---


## create!() [](#method-c-create-21)
         
PUT _ingest/pipeline/<pipeline-name>  
        
---


## delete!() [](#method-c-delete-21)
         
DELETE _ingest/pipeline/<pipeline-name>  
        
---


## exists?() [](#method-c-exists-3F)
         
  
        
---


## find(id=nil) [](#method-c-find)
         
  
        
---


## new() [](#method-c-new)
         
  
        
---


## processor(type, opts = {}) [](#method-c-processor)
         
  
        
---


## simulate(docs, verbose: true) [](#method-c-simulate)
         
  
        
---


## to_hash() [](#method-c-to_hash)
         
  
        
---


# Protected Class Methods

      
## not_found() [](#method-c-not_found)
         
  
        
---


# Public Instance Methods

      
## client() [](#method-i-client)
         
  
        
---


## exists?() [](#method-i-exists-3F)
         
  
        
---


## find() [](#method-i-find)
         
GET _ingest/pipeline/<pipeline-name>  
        
---


## simulate(docs, verbose: true) [](#method-i-simulate)
         
Simulates the pipeline.

Request body fields

The following table lists the request body fields used to run a pipeline.

Field     Required    Type       Description
docs      Required     Array       The documents to be used to test the pipeline.
pipeline  Optional Object  The pipeline to be simulated. If the pipeline identifier is not included, then the response simulates the latest pipeline created.
The docs field can include subfields listed in the following table.

Field     Required    Type       Description
source    Required   Object    The document’s JSON body.
id        Optional       String        A unique document identifier. The identifier cannot be used elsewhere in the index.
index     Optional    String     The index where the document’s transformed data appears.  
        
---


## to_hash() [](#method-i-to_hash)
         
  
        
---

