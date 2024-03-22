# Stretchy::Relations::Scoping::Default::ClassMethods [](#module-Stretchy::Relations::Scoping::Default::ClassMethods) [](#top)

    

# Public Instance Methods

      
## unscoped() { || ... } [](#method-i-unscoped)
         
Returns a scope for the model without the previously set scopes.

  class Post < ActiveRecord::Base
    def self.default_scope
      where published: true
    end
  end

  Post.all                                  # Fires "SELECT * FROM posts WHERE published = true"
  Post.unscoped.all                         # Fires "SELECT * FROM posts"
  Post.where(published: false).unscoped.all # Fires "SELECT * FROM posts"

This method also accepts a block. All queries inside the block will
not use the previously set scopes.

  Post.unscoped {
    Post.limit(10) # Fires "SELECT * FROM posts LIMIT 10"
  }  
        
---


# Protected Instance Methods

      
## default_scope(scope = nil) [](#method-i-default_scope)
         
Use this macro in your model to set a default scope for all operations on
the model.

  class Article < ActiveRecord::Base
    default_scope { where(published: true) }
  end

  Article.all # => SELECT * FROM articles WHERE published = true

The +default_scope+ is also applied while creating/building a record.
It is not applied while updating a record.

  Article.new.published    # => true
  Article.create.published # => true

(You can also pass any object which responds to +call+ to the
+default_scope+ macro, and it will be called when building the
default scope.)

If you use multiple +default_scope+ declarations in your model then
they will be merged together:

  class Article < ActiveRecord::Base
    default_scope { where(published: true) }
    default_scope { where(rating: 'G') }
  end

  Article.all # => SELECT * FROM articles WHERE published = true AND rating = 'G'

This is also the case with inheritance and module includes where the
parent or module defines a +default_scope+ and the child or including
class defines a second one.

If you need to do more complex things with a default scope, you can
alternatively define it as a class method:

  class Article < ActiveRecord::Base
    def self.default_scope
      # Should return a scope, you can call 'super' here etc.
    end
  end  
        
---

