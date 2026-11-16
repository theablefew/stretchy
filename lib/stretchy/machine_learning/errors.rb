module Stretchy::MachineLearning::Errors
  class ResourceMissingError < StandardError
    def initialize(msg="The resource is missing from the cluster.")
      super
    end
  end

  class ModelNotDeployedError < StandardError
    def initialize(msg="Model is not deployed. Please run `rake stretchy:ml:deploy` to deploy it.")
      super
    end
  end

  class ModelNotRegisteredError < StandardError
    def initialize(msg="Model is not registered. Please run `rake stretchy:ml:register` to register it.")
      super
    end
  end

  class ModelMissingError < StandardError
    def initialize(msg="Model is missing. Please run `rake stretchy:ml:register` to register it.")
      super
    end
  end

  class ConnectorMissingError < StandardError
    def initialize(msg="Connector is missing. Please run `rake stretchy:ml:connector:create` to create it.")
      super
    end
  end

  class ModelGroupMissingError < ResourceMissingError
    def initialize(msg="Model group is missing. Register it with `register!`.")
      super
    end
  end

  class AgentNotRegisteredError < ResourceMissingError
    def initialize(msg="Agent is not registered. Please run `rake stretchy:ml:agent:create` to create it.")
      super
    end
  end
end