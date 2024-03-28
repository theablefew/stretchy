# Stretchy::IndexSetting [](#class-Stretchy::IndexSetting) [](#top)
This class is used to define settings for an Elasticsearch index. 
It provides methods to define analyzers, filters, tokenizers, and normalizers.

## Usage
```ruby
class MyIndexSetting < Stretchy::IndexSetting
  analyzer :default, 
           filter: [:lowercase, :asciifolding],
           tokenizer: :standard

  filter :my_stemmer,
         type: :stemmer,
         name: :light_english

  tokenizer :path_tokenizer, 
            type: :path_hierarchy,
            reverse: true

  normalizer :my_normalizer, 
             type: :custom,
             filter: [:lowercase]
end
```

In this example, we define a custom index setting `MyIndexSetting` that includes a default analyzer, a custom filter, a custom tokenizer, and a custom normalizer.

## Methods
- `analyzer(name, options)`: Defines an analyzer with the given name and options.
- `filter(name, options)`: Defines a filter with the given name and options.
- `tokenizer(name, options)`: Defines a tokenizer with the given name and options.
- `normalizer(name, options)`: Defines a normalizer with the given name and options.

Each of these methods takes a name as the first argument and a hash of options as the second argument. The options will depend on the specific type of analyzer, filter, tokenizer, or normalizer being defined.

### Accessing Defined Settings
You can access the settings defined in an `IndexSetting` subclass using the `analyzers`, `filters`, `tokenizers`, and `normalizers` methods. These methods return a hash of the defined settings for their respective type.

```ruby
 MyIndexSetting.analyzers
 # => { default: { filter: [:lowercase, :asciifolding], tokenizer: :standard } }
```

```ruby
 MyIndexSetting.filters
 # => { my_stemmer: { type: :stemmer, name: :light_english } }
```

```ruby
 MyIndexSetting.tokenizers
 # => { path_tokenizer: { type: :path_hierarchy, reverse: true } }
```

```ruby
 MyIndexSetting.normalizers
 # => { my_normalizer: { type: :custom, filter: [:lowercase] } }
```
### Using the Settings
You can use the settings defined in an `IndexSetting` subclass to configure the settings for a `StretchyModel`.

```ruby
class MyModel < StretchyModel
 index_settings(MyIndexSetting.as_json)
end
```
    
## Constants
| Name | Description |
| ---- | ----------- |
| **METHODS[](#METHODS)** | Not Documented |

# Public Class Methods

      
## as_json() [](#method-c-as_json)
         
  
        
---


## settings() [](#method-c-settings)
         
  
        
---

