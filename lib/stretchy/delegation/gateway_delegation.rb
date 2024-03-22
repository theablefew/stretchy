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

      # This method is used to set or retrieve the index name for the Elasticsearch index.
      #
      # ### Parameters
      #
      # - `name:` (String, nil) - The name to set for the index. If nil, the method will act as a getter.
      # - `&block:` A block that returns the index name when called.
      #
      # ### Returns
      #
      # - (String) - The index name.
      #
      # ### Behavior
      #
      # - If a name or block is provided, it sets the index name to the provided name or block.
      # - If no argument is provided, it retrieves the index name. 
      # - If the index name is callable (e.g., a Proc), it calls the block.
      # - If the index name is not set, it defaults to the parameterized and underscored collection name of the base class model.
      #
      # ### Example
      #
      # In this example, the index name for instances of `MyModel` will be "my_custom_index" instead of "my_models".
      #
      # ```ruby
      # class MyModel < Stretchy::Record
      #   index_name "my_custom_index"
      # end
      # ```
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

      # This method is used to set or retrieve the settings for the Elasticsearch index.
      #
      # ### Parameters
      #
      # - `settings:` (Hash) - The settings to set for the index. If empty, the method will act as a getter.
      #
      # ### Returns
      #
      # - (Hash) - The index settings.
      #
      # ### Behavior
      #
      # - If settings are provided, it sets the index settings to the provided settings.
      # - If no argument is provided, it retrieves the index settings. 
      # - If the `default_pipeline` is set, it merges it into the index settings.
      #
      # ### Example
      #
      # ```ruby
      # class MyModel < Stretchy::Record
      #   index_settings number_of_shards: 5, number_of_replicas: 1
      # end
      # ```
      # In this example, the index settings for instances of `MyModel` will have 5 shards and 1 replica.
      def index_settings(settings={})
        @index_settings ||= settings
        @index_settings.merge!(default_pipeline: default_pipeline.to_s) if default_pipeline
        @index_settings.with_indifferent_access
      end

      def reload_gateway_configuration!
        @gateway = nil
      end

      # This method is used to access the underlying `Stretchy::Repository` for the model. It creates the repository if it doesn't exist, and reuses it if it does.
      #
      # ### Parameters
      #
      # - `&block:` (optional) A block that is evaluated in the context of the repository. This can be used to perform operations on the repository.
      #
      # ### Returns
      #
      # - (Stretchy::Repository) - The repository for the model.
      #
      # ### Behavior
      #
      # - If the repository doesn't exist or if the client of the existing repository is not the current client from the Stretchy configuration, 
      #   it creates a new repository with the current `client`, `index_name`, `class`, `mapping`, and `settings`.
      # - If a block is given, it is evaluated in the context of the repository.
      # - It always returns the repository.
      #
      # ### Example
      #
      # ```ruby
      # class MyModel < Stretchy::Record
      #   gateway do
      #     # Perform operations on the repository
      #   end
      # end
      # ```
      #
      def gateway(&block)
          reload_gateway_configuration! if @gateway && @gateway.client != Stretchy.configuration.client

          @gateway ||= Stretchy::Repository.create(client: Stretchy.configuration.client, index_name: index_name, klass: base_class, mapping: base_class.attribute_mappings.merge(dynamic: true), settings: index_settings) 
          # block.arity < 1 ? @gateway.instance_eval(&block) : block.call(@gateway) if block_given?
          @gateway
      end

    end
  end
end
