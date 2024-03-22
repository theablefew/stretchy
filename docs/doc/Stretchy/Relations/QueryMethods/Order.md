# Stretchy::Relations::QueryMethods::Order [](#module-Stretchy::Relations::QueryMethods::Order) [](#top)

    

# Public Instance Methods

      
## order(*args) [](#method-i-order)
_aliased as_ `sort`
         
Allows you to add one or more sorts on specified fields.

This method is used to sort the results of a query based on one or more fields. It accepts a variable number of arguments,
each of which is a hash where the key is the field name and the value is the sort direction or a hash of sort options.

### Parameters

- `args:` The Array of hashes representing the sort fields and directions or options (default: []).
    - `:attribute:` The Symbol or String representing the field name.
    - `:direction:` The Symbol representing the sort direction (:asc or :desc).
    - `:options:` The Hash representing the sort options (optional).
        - `:order:` The Symbol representing the sort direction (:asc or :desc).
        - `:mode:` The Symbol representing the sort mode (:avg, :min, :max, :sum, :median).
        - `:numeric_type:` The Symbol representing the numeric type (:double, :long, :date, :date_nanos).
        - `:missing:` The value to use for documents without the field.
        - `:nested:` The Hash representing the nested sort options.
            - `:path:` The String representing the path to the nested object.
            - `:filter:` The Hash representing the filter to apply to the nested object.
            - `:max_children:` The Integer representing the maximum number of children to consider per root document when picking the sort value.

### Returns
Returns a new Stretchy::Relation with the specified order.

---

### Examples

#### Single field

```ruby
  Model.order(created_at: :asc)
```

#### Multiple fields

```ruby
  Model.order(age: :desc, name: :asc, price: {order: :desc, mode: :avg})
```  
        
---


## sort(*args) [](#method-i-sort)
         
Alias for {#order}
@see #order  
        
---

