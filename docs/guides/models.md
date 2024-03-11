# Models


## Creating Stretchy Documents

Create your models in app/models and subclass the `Stretchy::Record` class. 

```ruby
class Profile < Stretchy::Record
end
```

The index name `profiles` will be inferred from the `Profile` model. 

### Overriding Naming Conventions

If you need a different naming convention for your indexes, you can override the default conventions.

```ruby
class Profile < Stretchy::Record
    index_name 'user_profiles'
end
```

### Default Sorting

By default Stretchy Models are sorted by `created_at`. If you have another field you'd like to sort by you can easily change it. 


```ruby
class Profile < Stretchy::Record
     default_sort_key :updated_at
end
```


## Attributes


Attributes are defined using `Active::Model` attributes. 

* `:big_integer`
* `:binary`
* `:boolean`
* `:date`
* `:datetime`
* `:decimal`
* `:float`
* `:integer`
* `:string`
* `:time`

In addition to the types available in `Active::Model` stretchy defines additional attribute types
suitable for use with Elasticsearch.

* `:array` - used to store multiple values in a single field
* `:hash` - used for structured JSON objects. Each field can be of any data type, including another object
* `:keyword` - use it for exact match searches, sorting, and aggregations

In Elasticsearch, :string and :keyword are two different data types that are used for different purposes.

A `:string` field is analyzed, which means that its value is broken down into separate searchable terms. For example, the string "quick brown fox" might be broken down into the terms "quick", "brown", and "fox". This makes :string fields suitable for full-text search where you want to find partial matches or search for individual words within a field.

On the other hand, a `:keyword` field is not analyzed and is used for exact match searches, sorting, and aggregations. The entire value of the field is used as a single term. For example, the string "quick brown fox" is a single term. This makes `:keyword` fields suitable for filtering, sorting, and aggregations where you need the exact value of the field.

In Stretchy, when you define a field as `:keyword`, it's like defining a `:string` field but with the `.keyword` notation added in queries, aggregations, and filters. This tells Elasticsearch to treat the field as a `:keyword` field and use the entire field value as a single term.




```ruby
class Profile < Stretchy::Record

    attribute :first_name,  :keyword
    attribute :last_name,   :keyword
    attribute :geo,         :hash
    attribute :bio,         :string
    attribute :age,         :integer
    attribute :score,       :float
    attribute :joined,      :date_time
    attribute :fav_flowers, :array
    attribute :visible,     :boolean, default: true

end

```

>__NOTE__
>
> `created_at`, `updated_at` and `id` are automatically included





### CRUD: Reading and Writing Data


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
validates :first_name, presence: true
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
class Zoo < Stretchy::Record
    has_many :animals
end
```

>[!WARNING]
>
> Because Elasticsearch is not a relational database, there are no join statements. This means associations will generate additional queries to fetch data.


