module Stretchy::MachineLearning
  class Registry < StretchyModel

    index_name ".stretchy_ml_registry_#{Stretchy.env}"

    attribute :model_id, :keyword
    attribute :model_group_id, :keyword
    attribute :deploy_task_id, :keyword
    attribute :register_task_id, :keyword
    attribute :class_name, :keyword

    def self.register(**args) 
      self.create_index! unless index_exists?
      where(class_name: args[:class_name]).first || create(**args)
    end

  end
end