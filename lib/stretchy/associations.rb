module Stretchy
  module Associations
    extend ActiveSupport::Concern

    def save!
        self.save
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
      ElasticRelation.new @@_associations[association], (dirty[association.to_sym] || [])
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

      def belongs_to(association, options = {})
        @@_association_options[association] = {
          foreign_key: "#{association}_id", 
          primary_key: "id",
          class_name: association
        }.reverse_merge(options)

        klass = @@_association_options[association][:class_name].to_s.singularize.classify.constantize
        @@_associations[association] = klass

        define_method(association.to_sym) do
          klass.where(_id: self.send(@@_association_options[association][:foreign_key].to_sym)).first
        end

        define_method("#{association}=".to_sym) do |val|
          options = @@_association_options[association] 
          instance_variable_set("@#{options[:foreign_key]}", val.send(options[:primary_key]))
        end
      end

      def has_one(association, class_name: nil, foreign_key: nil, dependent: :destroy)

        klass = association.to_s.singularize.classify.constantize unless class_name.present?
        foreign_key = "#{self.name.downcase}_id" unless foreign_key.present?
        @@_associations[association] = klass

        define_method(association.to_sym) do
          klass.where("#{foreign_key}": self.id).first
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
        ElasticRelation.new @@_associations[association]
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