# Stretchy::Associations [](#module-Stretchy::Associations) [](#top)

    

# Public Instance Methods

      
## _destroy() [](#method-i-_destroy)
         
  
        
---


## _destroy=(bool) [](#method-i-_destroy-3D)
         
  
        
---


## _type() [](#method-i-_type)
         
  
        
---


## accepts_nested_attributes_for(association) [](#method-i-accepts_nested_attributes_for)
         
  
        
---


## after_save_objects(s, association) [](#method-i-after_save_objects)
         
  
        
---


## association_names() [](#method-i-association_names)
         
  
        
---


## association_reflection(association) [](#method-i-association_reflection)
         
  
        
---


## belongs_to(association, options = {}) [](#method-i-belongs_to)
         
The belongs_to method is used to set up a one-to-one connection with another model.
This indicates that this model has exactly one instance of another model.
For example, if your application includes authors and books, and each book can be assigned exactly one author,
you'd declare the book model to belong to the author model.

association:: [Symbol] the name of the association
options:: [Hash] a hash to set up options for the association
          :foreign_key - the foreign key used for the association. Defaults to "#{association}_id"
          :primary_key - the primary key used for the association. Defaults to "id"
          :class_name - the name of the associated object's class. Defaults to the name of the association

Example:
  belongs_to :author

This creates a book.author method that returns the author of the book.
It also creates an author= method that allows you to assign the author of the book.  
        
---


## dirty() [](#method-i-dirty)
         
  
        
---


## find_or_create_by(**args) [](#method-i-find_or_create_by)
         
  
        
---


## has_many(association, options = {}) [](#method-i-has_many)
         
The has_many method is used to set up a one-to-many connection with another model.
This indicates that this model can be matched with zero or more instances of another model.
For example, if your application includes authors and books, and each author can have many books,
you'd declare the author model to have many books.

association:: [Symbol] the name of the association
options:: [Hash] a hash to set up options for the association
          :foreign_key - the foreign key used for the association. Defaults to "#{self.name.downcase}_id"
          :primary_key - the primary key used for the association. Defaults to "id"
          :class_name - the name of the associated object's class. Defaults to the name of the association
          :dependent - if set to :destroy, the associated object will be destroyed when this object is destroyed. This is the default behavior.

Example:
  has_many :books

This creates an author.books method that returns a collection of books for the author.
It also creates a books= method that allows you to assign the books for the author.  
        
---


## has_one(association, options = {}) [](#method-i-has_one)
         
The has_one method is used to set up a one-to-one connection with another model.
This indicates that this model contains the foreign key.

association:: [Symbol] The name of the association.
options:: [Hash] A hash to set up options for the association.
          :class_name - The name of the associated model. If not provided, it's derived from +association+.
          :foreign_key - The name of the foreign key on the associated model. If not provided, it's derived from the name of this model.
          :dependent - If set to +:destroy+, the associated object will be destroyed when this object is destroyed. This is the default behavior.
          :primary_key - The name of the primary key on the associated model. If not provided, it's assumed to be +id+.

Example:
  has_one :profile

This creates a user.profile method that returns the profile of the user.
It also creates a profile= method that allows you to assign the profile of the user.  
        
---


## marked_for_destruction?() [](#method-i-marked_for_destruction-3F)
         
  
        
---


## new_record?() [](#method-i-new_record-3F)
         
  
        
---


## reflect_on_association(association) [](#method-i-reflect_on_association)
         
  
        
---


## save!() [](#method-i-save-21)
         
  
        
---


## save_associations() [](#method-i-save_associations)
         
  
        
---


## type() [](#method-i-type)
         
Required for Elasticsearch < 7  
        
---


## update_all(records, **attributes) [](#method-i-update_all)
         
  
        
---


## validates_associated(*attr_names) [](#method-i-validates_associated)
         
  
        
---

