module Stretchy::MachineLearning
  # Remembers the ids the cluster assigned to each ML resource class.
  class Registry < StretchyModel

    index_name ".stretchy_ml_registry_#{Stretchy.env}"

    attribute :remote_id, :keyword
    attribute :model_id, :keyword
    attribute :model_group_id, :keyword
    attribute :deploy_task_id, :keyword
    attribute :register_task_id, :keyword
    attribute :class_name, :keyword
    attribute :class_type, :keyword

    def self.register(**args) 
      self.create_index! unless index_exists?
      where(class_name: args[:class_name]).first || create(**args)
    end

    # Entries written before `remote_id` existed kept the id in `model_id`.
    def remote_id
      super || model_id
    end

  end
end
