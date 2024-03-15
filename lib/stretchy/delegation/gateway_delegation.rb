module Stretchy
  module Delegation
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
                :count,
        to: :gateway

      include Rails::Instrumentation::Publishers::Record

      def index_name(name=nil, &block)
          if name || block_given?
            return (@index_name = name || block)
          end

          if @index_name.respond_to?(:call)
            @index_name.call
          else
            @index_name || base_class.model_name.collection.parameterize.underscore
          end
      end

      def reload_gateway_configuration!
        @gateway = nil
      end

      def gateway(&block)
          reload_gateway_configuration! if @gateway && @gateway.client != Stretchy.configuration.client
            
          @gateway ||= Stretchy::Repository.create(client: Stretchy.configuration.client, index_name: index_name, klass: base_class, mapping: base_class.attribute_mappings.merge(dynamic: true)) 
          # block.arity < 1 ? @gateway.instance_eval(&block) : block.call(@gateway) if block_given?
          @gateway
      end

    end
  end
end
