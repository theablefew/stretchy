module Elasticsearch
  module Persistence
    module Model
      module GatewayDelegation
        delegate :settings,
          :mappings,
          :mapping,
          :document_type,
          :document_type=,
          :index_name,
          :index_name=,
          :search,
          :find,
          :exists?,
          :create_index!,
          :delete_index!,
          :index_exists?,
          :refresh_index!,
          to: :gateway
      end
    end
  end
end
