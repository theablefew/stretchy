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

* `:hash`
* `:array`

```ruby
class Profile < Stretchy::Record

    attribute :first_name,  :string
    attribute :last_name,   :string
    attribute :geo,         :hash
    attribute :bio,         :string
    attribute :age,         :integer
    attribute :score,       :float
    attribute :joined,      :date_time
    attribute :fav_flowers, :array

end

```

>[!NOTE]
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


