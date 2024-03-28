module Stretchy::MachineLearning::Errors
  class ModelNotDeployedError < StandardError; end
  class ModelNotRegisteredError < StandardError; end
  class ModelMissingError < StandardError; end
end