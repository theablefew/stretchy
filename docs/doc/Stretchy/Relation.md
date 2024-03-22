# Stretchy::Relation [](#class-Stretchy::Relation) [](#top)
This class represents a relation to Elasticsearch documents.
It provides methods for querying and manipulating the documents.
    
## Constants
| Name | Description |
| ---- | ----------- |
| **INVALID_METHODS_FOR_DELETE_ALL[](#INVALID_METHODS_FOR_DELETE_ALL)** | <p>These methods cannot be used with the <code>delete_all</code> method.</p> |

### Attributes

#### klass[R] [](#attribute-i-klass)
_aliased as_ `model`
 
 

#### loaded[R] [](#attribute-i-loaded)
_aliased as_ `loaded?`
 
 

#### loaded?[R] [](#attribute-i-loaded-3F)
 
 

#### model[R] [](#attribute-i-model)
 
 

---


# Public Class Methods

      
## new(klass, values={}) [](#method-c-new)
         
Initialize a new instance of the relation.

This constructor method is used to create a new instance of the relation. It accepts a class representing the Elasticsearch documents and a hash of initial values for the relation.

### Parameters

- `klass:` The Class representing the Elasticsearch documents.
- `values:` The Hash representing the initial values for the relation (optional).

### Returns
Returns a new instance of the relation.

---

### Examples

#### Initialize a new relation

```ruby
  relation = Relation.new(Model, {name: 'John Doe', age: 30})
```  
        
---


# Public Instance Methods

      
## as_json(options = nil) [](#method-i-as_json)
         
Returns the results of the relation as a JSON object.

This instance method is used to get the results of the relation as a JSON object. It calls the `as_json` method on the results of the relation and passes any provided options to it.

### Parameters

- `options:` The Hash representing the options to pass to the `as_json` method (optional).

### Returns
Returns a Hash representing the results of the relation as a JSON object.

---

### Examples

#### Get the results of a relation as a JSON object

```ruby
  relation = Relation.new(Model, {name: 'John Doe', age: 30})
  json_results = relation.as_json
```  
        
---


## build(*args) [](#method-i-build)
         
Initialize a new instance of the relation.

This constructor method is used to create a new instance of the relation. It accepts a class representing the Elasticsearch documents and a hash of initial values for the relation.

### Parameters

- `klass:` The Class representing the Elasticsearch documents.
- `values:` The Hash representing the initial values for the relation (optional).

### Returns
Returns a new instance of the relation.

---

### Examples

#### Initialize a new relation

```ruby
  relation = Relation.new(Model, {name: 'John Doe', age: 30})
```  
        
---


## create(*args, &block) [](#method-i-create)
         
Creates a new Elasticsearch document.

This instance method is used to create a new Elasticsearch document within the scope of the relation. It accepts a list of arguments and an optional block to pass to the document constructor.

### Parameters

- `*args:` A list of arguments to pass to the document constructor.
- `&block:` An optional block to pass to the document constructor.

### Returns
Returns the newly created document.

---

### Examples

#### Create a new document within the scope of a relation

```ruby
  document = relation.create(name: 'John Doe', age: 30)
```  
        
---


## exec_queries() [](#method-i-exec_queries)
         
Executes the Elasticsearch query for the relation.

This instance method is used to execute the Elasticsearch query for the relation. It calls the `execute` method on the `query_builder` of the relation and stores the results in the `@records` instance variable.

### Returns
Returns an Array representing the results of the query.  
        
---


## fetch() [](#method-i-fetch)
         
_alias for `load`_  
        
---


## inspect() [](#method-i-inspect)
         
 Returns a string representation of the relation.

This instance method is used to get a string representation of the relation. It includes information about the total number of results, the maximum number of results, and any aggregations present in the response.

### Returns
Returns a String representing the relation.

---

### Examples

#### Get a string representation of a relation

```ruby
  Model.where(flight: 'goat').terms(:flights, field: :flight).inspect
  #=> #<Stretchy::Relation total: 0, max: 0, aggregations: ["flights"]> 
```  
        
---


## load() [](#method-i-load)
_aliased as_ `fetch`
         
Loads the results of the relation.

This instance method is used to load the results of the relation. It calls the `exec_queries` method to execute the queries unless the results have already been loaded.

### Returns
Returns the relation object itself.

---

### Examples

#### Load the results of a relation

```ruby
  relation = Model.where(flight: 'goat')
  relation.load
```  
        
---


## response() [](#method-i-response)
         
Returns the raw Elasticsearch response for the relation.

This instance method is used to get the raw Elasticsearch response for the relation. It calls the `results` method to load the results and then returns the `response` property of the results.

### Returns
Returns a Hash representing the raw Elasticsearch response for the relation.

---

### Examples

#### Get the raw Elasticsearch response for a relation

```ruby
  relation = Relation.new(Model, {name: 'John Doe', age: 30})
  raw_response = relation.response
```

#### With a model
```ruby
 relation = Model.where(name: 'John Doe')
 raw_response = relation.response
 #=> {"took"=>3, "timed_out"=>false, "_shards"=>{"total"=>1, "successful"=>1, "skipped"=>0, "failed"=>0}, "hits"=>{"total"=>{"value"=>0, "relation"=>"eq"}, "max_score"=>nil, "hits"=>[]}}
```  
        
---


## results() [](#method-i-results)
_aliased as_ `to_a`
         
Returns the results of the relation as an array.

This instance method is used to load the results of the relation and return them as an array. It calls the `load` method to load the results and then returns the `@records` instance variable.

### Returns
Returns an Array representing the results of the relation.

---

### Examples

#### Get the results of a relation as an array

```ruby
  relation = Relation.new(Model, {name: 'John Doe', age: 30})
  results = relation.results
```  
        
---


## scoping() { || ... } [](#method-i-scoping)
         
Executes a block of code within the scope of the relation.

This instance method is used to execute a block of code within the scope of the relation. It temporarily sets the current scope of the class to this relation, executes the block, and then resets the current scope to its previous value.

### Parameters

- `&block:` The block of code to execute within the scope of the relation.

### Returns
Returns the result of the block execution.  
        
---


## to_a() [](#method-i-to_a)
         
_alias for `results`_  
        
---


## to_elastic() [](#method-i-to_elastic)
         
Returns the Elasticsearch query for the relation.

This instance method is used to get the Elasticsearch query for the relation. It calls the `to_elastic` method on the `query_builder` of the relation.

### Returns
Returns a Hash representing the Elasticsearch query for the relation.

---

### Examples

#### Get the Elasticsearch query for a relation

```ruby
  Model.where(flight: 'goat').to_elastic
  #=> {"query"=>{"bool"=>{"must"=>{"term"=>{"flight.keyword"=>"goat"}}}}}
```  
        
---


## values() [](#method-i-values)
         
Returns the values of the relation as a hash.

This instance method is used to get the values of the relation as a hash. It converts the `@values` instance variable to a hash and returns it.

### Returns
Returns a Hash representing the values of the relation.

---

### Examples

#### Get the values of a relation

```ruby
  relation = Model.where(flight: 'goat')
  values = relation.values
```  
        
---

