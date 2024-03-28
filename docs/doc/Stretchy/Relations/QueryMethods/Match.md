# Stretchy::Relations::QueryMethods::Match [](#module-Stretchy::Relations::QueryMethods::Match) [](#top)

    

# Public Instance Methods

      
## match(opts = :chain, *rest) [](#method-i-match)
         
This method is used to add conditions to the query.

### Parameters

- `query:` (Required) - Text, number, boolean value or date you wish to find in the provided field. The match query analyzes any provided text before performing a search. This means the match query can search text fields for analyzed tokens rather than an exact term.
- `options:` (Optional) - A hash of options to customize the match query. Options include:
  - `analyzer:` (string) - Analyzer used to convert the text in the query value into tokens. Defaults to the index-time analyzer mapped for the field. If no analyzer is mapped, the index’s default analyzer is used.
  - `auto_generate_synonyms_phrase_query:` (Boolean) - If true, match phrase queries are automatically created for multi-term synonyms. Defaults to true.
  - `boost:` (float) - Floating point number used to decrease or increase the relevance scores of the query. Defaults to 1.0.
  - `fuzziness:` (string) - Maximum edit distance allowed for matching.
  - `max_expansions:` (integer) - Maximum number of terms to which the query will expand. Defaults to 50.
  - `prefix_length:` (integer) - Number of beginning characters left unchanged for fuzzy matching. Defaults to 0.
  - `fuzzy_transpositions:` (Boolean) - If true, edits for fuzzy matching include transpositions of two adjacent characters (ab → ba). Defaults to true.
  - `fuzzy_rewrite:` (string) - Method used to rewrite the query.
  - `lenient:` (Boolean) - If true, format-based errors, such as providing a text query value for a numeric field, are ignored. Defaults to false.
  - `operator:` (string) - Boolean logic used to interpret text in the query value. Valid values are: OR (Default), AND.
  - `minimum_should_match:` (string) - Minimum number of clauses that must match for a document to be returned.
  - `zero_terms_query:` (string) - Indicates whether no documents are returned if the analyzer removes all tokens, such as when using a stop filter. Valid values are: none (Default), all.

### Returns

Returns a Stretchy::Relation with the specified conditions applied.

### Examples

```ruby
  Model.match(path: "/new/things")
```  
        
---

