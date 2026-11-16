require 'opensearch/api/namespace/machine_learning/model'
require 'opensearch/api/namespace/connector'

module Stretchy
  module OpenSearchCompatibility
    extend ActiveSupport::Concern

    # Adds the ML Commons model and connector APIs to the OpenSearch client.
    def self.opensearch_patch!
      OpenSearch::API.send(:include, OpenSearch::API::MachineLearning::Models)
      OpenSearch::API.send(:include, OpenSearch::API::Connector)
    end
  end
end
