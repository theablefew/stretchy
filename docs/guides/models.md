# Models


## Creating Stretchy Documents

Create your models in app/models and subclass the `StretchyModel` class. 

```ruby
class Profile < StretchyModel
end
```

The index name `profiles` will be inferred from the `Profile` model. 

### Overriding Naming Conventions

If you need a different naming convention for your indexes, you can override the default conventions.

```ruby
class Profile < StretchyModel
    index_name 'user_profiles'
end
```

### Default Sorting

By default Stretchy Models are sorted by `created_at`. If you have another field you'd like to sort by you can easily change it. 


```ruby
class Profile < StretchyModel
     default_sort_key :updated_at
end
```


## Attributes


Attributes are defined using `Stretchy::Attributes::Type` attributes. 

* `:array` - Used to store multiple values in a single field.
* `:binary` - Used to store binary data as a `Base64` encoded string.
* `:boolean` - Used to store true or false values.
* `:constant_keyword` - Used for fields that will contain the same value across all documents.
* `:datetime` - Used to store date and time.
* `:flattened` - Used for indexing object hierarchies as a flat list.
* `:geo_point` - Used to store geographical locations as latitude/longitude points.
* `:geo_shape` - Used to store complex shapes like polygons.
* `:histogram` - Used to support aggregations on numerical data.
* `:hash` - Used for structured JSON objects. Each field can be of any data type, including another object.
* `:ip` - Used to store IP addresses.
* `:join` - Used to create parent/child relation within documents.
* `:keyword` - Used for exact match searches, sorting, and aggregations. This field is not analyzed.
* `:match_only_text` - Used for full-text search.
* `:nested` - Used to index arrays of objects as separate documents.
* `:percolator` - Used to store queries for matching documents.
* `:point` - Used to store points in space.
* `:rank_feature` - Used to boost relevance scores to rank features.
* `:text` - Used to store text. This field is analyzed, which means that its value is broken down into separate searchable terms.
* `:token_count` - Used to count the number of tokens in a string.
* `:dense_vector` - Used to store dense vectors of float values.
* `:search_as_you_type` - Used for full-text search, especially for auto-complete functionality.
* `:sparse_vector` - Used to store sparse vectors of float values.
* `:string` - Used to store text. This field is analyzed, which means that its value is broken down into separate searchable terms. _an alias of `:text`_
* `:version` - Used to store version numbers.
* `:wildcard` - Used for fields that will contain arbitrary strings.

#### Numeric Types
* `:long` - Used to store long integer numbers.
* `:integer` - Used to store integer numbers.
* `:short` - Used to store short integer numbers.
* `:byte` - Used to store byte data.
* `:double` - Used to store double-precision floating point numbers.
* `:float` - Used to store floating point numbers.
* `:half_float` - Used to store half-precision floating point numbers.
* `:scaled_float` - Used to store floating point numbers that are scaled by a specific factor.
* `:unsigned_long` - Used to store long integer numbers that are always positive.

#### Range Types
* `:integer_range` - Used to store ranges of integer numbers.
* `:float_range` - Used to store ranges of floating point numbers.
* `:long_range` - Used to store ranges of long integer numbers.
* `:double_range` - Used to store ranges of double-precision floating point numbers.
* `:date_range` - Used to store ranges of dates.
* `:ip_range` - Used to store ranges of IP addresses.

In Elasticsearch, :string and :keyword are two different data types that are used for different purposes.

A `:string` field is analyzed, which means that its value is broken down into separate searchable terms. For example, the string "quick brown fox" might be broken down into the terms "quick", "brown", and "fox". This makes `:string` fields suitable for full-text search where you want to find partial matches or search for individual words within a field.

On the other hand, a `:keyword` field is not analyzed and is used for exact match searches, sorting, and aggregations. The entire value of the field is used as a single term. For example, the string "quick brown fox" is a single term. This makes `:keyword` fields suitable for filtering, sorting, and aggregations where you need the exact value of the field.

In Stretchy, when you define a field as `:keyword`, it's like defining a `:string` or `:text` field but with the `.keyword` notation automatically added to the field in queries, aggregations, and filters. This tells Elasticsearch to treat the field as a `:keyword` field and use the entire field value as a single term.

Avoid using `:keyword` fields for full-text search. Use the `:text` type instead.


```ruby
class Profile < StretchyModel

    attribute :first_name,  :keyword
    attribute :last_name,   :keyword
    attribute :geo,         :hash
    attribute :bio,         :string
    attribute :age,         :integer
    attribute :score,       :float
    attribute :joined,      :datetime
    attribute :fav_flowers, :array
    attribute :visible,     :boolean, default: true

end

```

>__NOTE__
>
> `created_at`, `updated_at` and `id` are automatically included


All of the attribute types can receive additional parameters that are used to configure the mapping for the field. These parameters can be used to customize how the data is indexed and searched. For example, you can specify whether a field should be stored, whether it should be indexed, the data type of the field, and more.

Here's an example of how to use additional parameters with the :keyword attribute type:

```ruby
class Product < StretchyModel
    attribute :tag, :keyword, ignore_above: 256, time_series_dimension: true
end
```
In this example, ignore_above: 256 means that strings longer than 256 characters will not be indexed, and time_series_dimension: true indicates that the field is a time series dimension.

Refer to the documentation for each attribute type for a full list of available parameters and their meanings.

When working with `:hash` data types, it's often useful to specify the fields within that object for fine-tuned control over mappings. 

The `:hash` data type is used for structured JSON objects, where each field can be of any data type, including another object. This provides a flexible way to store complex data structures in a single field.

However, this flexibility can sometimes lead to less than optimal search performance or unexpected search results. For example, if a field within the hash object contains text, it might be analyzed and tokenized in a way that's not suitable for your use case.

To overcome this, you can specify the `:properties` within the hash object and their data types. This allows you to control how each field is indexed and searched. For example, you can specify that a field should be of type `:keyword` to ensure that it's not analyzed and can be used for exact match searches.

Here's an example of how to specify fields within a hash object:

```ruby
attribute :metadata, :hash, properties: {
  title: { type: :text },
  tags: { type: :keyword }
  checkins: { type: :array }
}
```
In this example, the metadata attribute is a hash object with fields: title, tags and checkins. The title field is of type `:text`, which means it will be analyzed and can be used for full-text search. The tags field is of type `:keyword`, which means it will not be analyzed and can be used for exact match searches. The checkins field is of type `:array` which means it can contain zero or more values.

> _**Note on arrays**_
>
>When adding a field dynamically, the first value in the array determines the field type. All subsequent values must be of the same data type or it must at least be possible to coerce subsequent values to the same data type.
>
>Arrays with a mixture of data types are not supported: [ 10, "some string" ]

By specifying the fields within the hash object, you have fine-tuned control over the mappings and can optimize the search performance and accuracy for your specific use case. 

### Reading and Writing Data


#### Create

The `new` method will return a new object while `create` with return the object and save it to the index. 

For example, given a model `Profile` with attributes `first_name`, `last_name`, and `age`, the `create` method call will create and save a new record to the index:

```ruby
profile = Profile.new(first_name: "Candy", last_name: "Mu", age: 33)
```

Using the `new` method, an object can be instatiated without being saved:

```ruby
profile = Profile.new
profile.first_name = "Candy"
profile.last_name = "Mu"
profile.age = 33
```

Calling `profile.save` will index the record. 

#### Read

Following the ActiveRecord API, Stretchy models have the familiar methods defined: 

```ruby
# return a collection with all profiles 
profiles = Profile.all
```

```ruby
# return the first profile
profile = Profile.first
```

```ruby
# find all profiles with age of 24 named Lori and sort by :created_at in descending order
profile = Profile.where(first_name: "Lori", age: 24).sort(created_at: :desc)
```

The full [Query Interface](guides/querying) guide goes into further depth on the API available for interacting with Stretchy models. 


#### Update

```ruby
profile = Profile.where(first_name: "Candy").first
profile.update(first_name: "Lilly")
```


#### Delete

```ruby
profile = Profile.where(first_name: "Lori")
profile.destory
```

### Bulk Operations

Bulk operations in Elasticsearch are a way to perform multiple operations in a single API call. This can greatly increase the speed of indexing and updating documents in Elasticsearch.

The bulk API makes it possible to perform many `index`, `update`, `create`, or `delete` operations in a single API call. This can greatly improve the indexing speed.

In the context of Stretchy, the `Model.bulk` method can be used to perform bulk operations. You can pass an array of records to this method, and each record will be processed according to the operation specified in its `to_bulk` method.

The `to_bulk` method is used to generate the structure for the bulk operation. By default, it performs an index operation, but you can also specify `:delete` or `:update` operations.

For large datasets, you can use the `Model.bulk_in_batches` method to perform bulk operations in batches. This method divides the records into batches of a specified size and processes each batch separately. This can be more memory-efficient than processing all records at once, especially for large datasets.

Here's an example of how you can use these methods:

```ruby
Model.bulk(records_as_bulk_operations)
```

#### Bulk helper
Generates structure for the bulk operation
```ruby
record.to_bulk # default to_bulk(:index)
record.to_bulk(:delete)
record.to_bulk(:update)
```

#### In batches
Run bulk operations in batches specified by `size`
```ruby
Model.bulk_in_batches(records, size: 100) do |batch|
    batch.map! { |record| Model.new(record).to_bulk }
end
```


### Validations

```ruby
class Profile < StretchyModel
    attribute :first_name, :string
    validates :first_name, presence: true
end
```

```irb
profile = Profile.new
profile.save
#=> First name can't be blank 
```

### Callbacks

* `:before_save`
* `:after_save`
* `:before_create`
* `:after_create`
* `:before_update`
* `:after_update`
* `:before_destroy`
* `:after_destroy`

### Associations
Associations can be made between models. While Elasticsearch is not a relational database, it is sometimes useful to have a link between records. 

```ruby
class Animal < StretchyModel
    attribute :name, :keyword
    attribute :zoo_id, :keyword

    belongs_to :zoo
end
```

```ruby
class Zoo < StretchyModel
    has_many :animals
end
```

```ruby (console)
zoo.animals
=> [#<Animal id: 1, name: "Panda", zoo_id: 1, created_at: 2024-03-15T01:03:38.395Z, updated_at: 2024-03-15T01:03:38.395Z>, 
#<Animal id: 2, name: "Lemur", zoo_id: 1, created_at: 2024-03-15T01:03:38.395Z, updated_at: 2024-03-15T01:03:38.395Z>]

```

Associations largely work the same as their Rails counterparts. The following association types are supported: 

* `belongs_to`
* `has_many`
* `has_one`


>__WARNING__
>
> Because Elasticsearch is not a relational database, there are no join statements. This means associations will generate additional queries to fetch data.


## Mappings

```ruby
class Report < StretchyModel
    attribute :title, :text, fields: false
    attribute :created_by, :keyword
    attribute :body, :text, term_vector: :with_positions_offsets

    index_name 'test_reports'

    mapping dynamic: 'strict' do
        attribute_mappings[:properties].each_pair do |attr, options|
            indexes attr, *options
        end
    end
end
```


```ruby
Report.attribute_mappings
=> {
  "properties" => {
    "id"         => {
      "type" => "keyword"
    },
    "created_at" => {
      "type" => "datetime"
    },
    "updated_at" => {
      "type" => "datetime"
    },
    "title"      => {
      "type" => "string"
    },
    "created_by" => {
      "type" => "keyword"
    },
    "body"       => {
      "type"        => "text",
      "term_vector" => "with_positions_offsets"
    }
  }
}
```

{"properties": {  
        "body": { 
          "type": "text",
          "fields": { 
            "keyword": { 
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "created_at": { 
          "type": "date"
        },
        "created_by": { 
          "type": "text",
          "fields": { 
            "keyword": {  
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "title": { 
          "type": "text",
          "fields": { 
            "keyword": { 
              "type": "keyword",
              "ignore_above": 256
            }
          }
        },
        "updated_at": { 
          "type": "date"
        }
      }
    }
