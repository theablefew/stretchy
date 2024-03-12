module Stretchy
  module Associations
    extend ActiveSupport::Concern

    def save!
      if valid?
        self.save
      else
        raise "Record is invalid"
      end
    end

    # Required for Elasticsearch < 7
    def type
      "_doc"
    end

    def _type
      "_doc"
    end

    def new_record?
      self.id.nil?
    end

    def marked_for_destruction?
      _destroy
    end

    def after_save_objects(s, association)
      @_after_save_objects ||= {}
      @_after_save_objects[association] ||= []
      @_after_save_objects[association] << self.send("build_#{association}", s)
    end

    def dirty
      @_after_save_objects || {}
    end

    def association_reflection(association)
      Stretchy::Relation.new @@_associations[association], (dirty[association.to_sym] || [])
    end

    def _destroy=(bool)
      @_destroy = bool
    end

    def _destroy
      return @_destroy
    end

    def save_associations
      @_after_save_objects.each_pair do |association, collection|
        collection.each do |instance|
          instance.send("#{@@_association_options[association.to_sym][:foreign_key]}=", self.id)
          instance.save
        end
      end unless @_after_save_objects.nil?
      @_after_save_objects = {}
    end

    class_methods do
      @@_associations ||= {}
      @@_association_options ||= {}

      # The belongs_to method is used to set up a one-to-one connection with another model.
      # This indicates that this model has exactly one instance of another model.
      # For example, if your application includes authors and books, and each book can be assigned exactly one author,
      # you'd declare the book model to belong to the author model.
      #
      # association:: [Symbol] the name of the association
      # options:: [Hash] a hash to set up options for the association
      #           :foreign_key - the foreign key used for the association. Defaults to "#{association}_id"
      #           :primary_key - the primary key used for the association. Defaults to "id"
      #           :class_name - the name of the associated object's class. Defaults to the name of the association
      #
      # Example:
      #   belongs_to :author
      #
      # This creates a book.author method that returns the author of the book.
      # It also creates an author= method that allows you to assign the author of the book.
      #
      def belongs_to(association, options = {})
        @@_association_options[association] = {
          foreign_key: "#{association}_id", 
          primary_key: "id",
          class_name: association
        }.merge(options)

        klass = @@_association_options[association][:class_name].to_s.singularize.classify.constantize
        @@_associations[association] = klass

        define_method(association.to_sym) do
          instance_variable_get("@#{association}") || 
            klass.where(_id: self.send(@@_association_options[association][:foreign_key].to_sym)).first
        end

        define_method("#{association}=".to_sym) do |val|
          options = @@_association_options[association] 
          self.send("#{options[:foreign_key]}=", val.send(options[:primary_key]))
          instance_variable_set("@#{association}", val)
        end

        define_method("build_#{association}") do |*args|
          associated_object = klass.new(*args)
          instance_variable_set("@#{association}", associated_object)
          associated_object
        end

        before_save do
          associated_object = instance_variable_get("@#{association}")
          if associated_object && associated_object.new_record?
            if associated_object.save!
              self.send("#{@@_association_options[association][:foreign_key]}=", associated_object.id)
            end
          end
        end
      end










      # The has_one method is used to set up a one-to-one connection with another model.
      # This indicates that this model contains the foreign key.
      #
      # association:: [Symbol] The name of the association.
      # options:: [Hash] A hash to set up options for the association.
      #           :class_name - The name of the associated model. If not provided, it's derived from +association+.
      #           :foreign_key - The name of the foreign key on the associated model. If not provided, it's derived from the name of this model.
      #           :dependent - If set to +:destroy+, the associated object will be destroyed when this object is destroyed. This is the default behavior.
      #           :primary_key - The name of the primary key on the associated model. If not provided, it's assumed to be +id+.
      #           
      #
      # Example:
      #   has_one :profile
      #
      # This creates a user.profile method that returns the profile of the user.
      # It also creates a profile= method that allows you to assign the profile of the user.
      #
      def has_one(association, options = {})

        @@_association_options[association] = {
          foreign_key: "#{self.name.underscore}_id", 
          primary_key: "id",
          class_name: association
        }.merge(options)

        klass = @@_association_options[association][:class_name].to_s.singularize.classify.constantize
        @@_associations[association] = klass

        foreign_key = @@_association_options[association][:foreign_key]

        define_method(association.to_sym) do
          instance_variable_get("@#{association}") || 
            klass.where("#{foreign_key}": self.id).first
        end

        define_method("#{association}=".to_sym) do |val|
          instance_variable_set("@#{association}", val)
        end
      end










      def has_many(association, klass, options = {})
        @@_associations[association] = klass

        opt_fk = options.delete(:foreign_key)
        foreign_key = opt_fk ? opt_fk : "#{self.name.split("::").last.tableize.singularize}_id"

        @@_association_options[association] = { foreign_key: foreign_key }

        define_method(association.to_sym) do
          args = {}
          args[foreign_key] = self.id
          self.new_record? ? association_reflection(association) : klass.where(args)
        end

        define_method("build_#{association}".to_sym) do |*args|
          opts = {}
          opts[foreign_key] = self.id
          args.first.merge! opts
          klass.new *args
        end
      end

      def validates_associated(*attr_names)
        validates_with AssociatedValidator, _merge_attributes(attr_names)
      end

      def accepts_nested_attributes_for(association)
        after_create :save_associations

        define_method("#{association}_attributes=".to_sym) do |*args|
          args.each do |key|
            key.values.each do |instance|
              self.after_save_objects(instance, association)
            end
          end

          association_reflection(association)
        end
      end

      def reflect_on_association(association)
        Stretchy::Relation.new @@_associations[association]
      end

      def update_all(records, **attributes)

        records.map do |record|
          attributes.each { |key, value| record.send("#{key}=", value) }
          record
        end.each_slice(100) do |batch|
          update_batch = batch.collect{ |m| m.to_bulk(:update)}
          self.gateway.client.bulk body: update_batch
        end

        self.refresh_index
        records

      end

      def association_names
        @@_associations.keys
      end

      def find_or_create_by(**args)
        self.where(args).first || self.create(args)
      end
    end
  end
end
