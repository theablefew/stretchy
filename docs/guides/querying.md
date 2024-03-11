# Querying

## .where
The `.where` method is used to filter the documents that should be returned from a search. It adds conditions to the `must` clause of the query, which means that only documents that match all of the conditions will be returned.

The `.where` method is flexible and can accept multiple conditions and different types of expressions. The `.where` method returns a new `Stretchy::Relation` object, so you can chain other methods onto it to further refine your search. Here are some examples of how it can be used:

#### Must
You can pass one or more key-value pairs to `.where` to search for documents where specific fields have specific values. For example, `Model.where(color: 'blue', title: 'Candy')` will return only documents where the `color` field is 'blue' and the `title` field is 'Candy'.
```ruby
Model.where(color: 'blue', :title: "Candy")
```

#### Ranges
You can use ranges to search for documents where a field's value falls within a certain range. For example,
```ruby
Model.where(date: 2.days.ago...1.day.ago)

Model.where(age: 18..30)

Model.where(price: {gte: 100, lt: 140})
```

#### Regex
You can use regular expressions to search for documents where a field's value matches a certain pattern.
```ruby
Model.where(name: /br.*n/i)
```

#### Terms
You can use an array of values to search for documents where a field's value is in the array.
```ruby
Model.where(name: ['Candy', 'Lilly'])
````

