module Stretchy
  # Deprecated: inherit from Stretchy::IngestPipeline.
  class Pipeline < IngestPipeline
    abstract!

    def self.inherited(subclass)
      Stretchy.deprecator.warn("Stretchy::Pipeline is deprecated and will be removed in stretchy-model 0.8. Inherit from Stretchy::IngestPipeline instead.")
      super
    end
  end
end
