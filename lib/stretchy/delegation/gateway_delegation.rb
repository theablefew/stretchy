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

      def index_name(name=nil, &block)
          if name || block_given?
            return (@index_name = name || block)
          end

          if @index_name.respond_to?(:call)
            @index_name.call
          else
            @index_name || base_class.model_name.collection
          end
      end

      def gateway(&block)
          @gateway ||= Stretchy::Repository.create(index_name: index_name, klass: base_class)
          block.arity < 1 ? @gateway.instance_eval(&block) : block.call(@gateway) if block_given?
          @gateway
      end

    end
  end
end
