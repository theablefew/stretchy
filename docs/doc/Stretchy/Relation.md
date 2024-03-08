# class Stretchy::Relation [](#class-Stretchy::Relation) [](#top)
This class represents a relation to Elasticsearch documents. It provides methods for querying and manipulating the documents.

 ## Constants
 | Name | Description |
 | ---- | ----------- |
 | **MULTI_VALUE_METHODS[](#MULTI_VALUE_METHODS)** | These methods can accept multiple values. |
 | **SINGLE_VALUE_METHODS[](#SINGLE_VALUE_METHODS)** | These methods can accept a single value. |
 | **INVALID_METHODS_FOR_DELETE_ALL[](#INVALID_METHODS_FOR_DELETE_ALL)** | These methods cannot be used with the ‘delete\_all` method. |
 | **VALUE_METHODS[](#VALUE_METHODS)** | All value methods. |
 ## Attributes
 ### klass[R] [](#attribute-i-klass)
 Getters.

 ### loaded[R] [](#attribute-i-loaded)
 Getters.

 ### loaded?[R] [](#attribute-i-loaded-3F)
 Getters.

 ### model[R] [](#attribute-i-model)
 Getters.

 ## Public Class Methods
 ### new(klass, values={}) [](#method-c-new)
 Constructor.

@param klass [Class] The class of the Elasticsearch documents. @param values [Hash] The initial values for the relation.

 ## Public Instance Methods
 ### as_json(options = nil) [](#method-i-as_json)
 Returns the results of the relation as a JSON object.

@param options [Hash] The options to pass to the ‘as\_json` method. @return [Hash] The results of the relation as a JSON object.

 ### build(*args) [](#method-i-build)
 Builds a new Elasticsearch document.

@param args [Array] The arguments to pass to the document constructor. @return [Object] The new document.

 ### create(*args, &block) [](#method-i-create)
 Creates a new Elasticsearch document.

@param args [Array] The arguments to pass to the document constructor. @param block [Proc] The block to pass to the document constructor. @return [Object] The new document.

 ### delete(opts=nil) [](#method-i-delete)
 Deletes Elasticsearch documents.

@param opts [Hash] The options for the delete operation.

 ### exec_queries() [](#method-i-exec_queries)
 Executes the Elasticsearch query for the relation.

@return [Array] The results of the query.

 ### fetch() [](#method-i-fetch)
 ### inspect() [](#method-i-inspect)
 Returns a string representation of the relation.

@return [String] The string representation of the relation.

 ### load() [](#method-i-load)
 Loads the results of the relation.

@return [Relation] The relation object.

 ### response() [](#method-i-response)
 ### results() [](#method-i-results)
 ### scoping() { || ... } [](#method-i-scoping)
 Executes a block of code within the scope of the relation.

@yield The block of code to execute.

 ### to_a() [](#method-i-to_a)
 Returns the results of the relation as an array.

@return [Array] The results of the relation.

 ### to_elastic() [](#method-i-to_elastic)
 Returns the Elasticsearch query for the relation.

@return [Hash] The Elasticsearch query for the relation.

 ### values() [](#method-i-values)
 Returns the values of the relation as a hash.

@return [Hash] The values of the relation.

 