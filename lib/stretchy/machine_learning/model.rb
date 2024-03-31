require 'stretchy/machine_learning/errors'

module Stretchy 
  module MachineLearning
    class Model

      PRETRAINED_MODELS = {
        :neural_sparse => {
          :encoding => 'amazon/neural-sparse/opensearch-neural-sparse-encoding-v1',
          :encoding_doc => 'amazon/neural-sparse/opensearch-neural-sparse-encoding-doc-v1',
          :tokenizer => 'amazon/neural-sparse/opensearch-neural-sparse-tokenizer-v1'
        },
        :cross_encoder => {
          :minilm_6 => 'huggingface/cross-encoders/ms-marco-MiniLM-L-6-v2',
          :minilm_12 => 'huggingface/cross-encoders/ms-marco-MiniLM-L-12-v2'
        },
        :sentence_transformers => {
          :roberta_all => 'huggingface/sentence-transformers/all-distilroberta-v1',
          :msmarco => 'huggingface/sentence-transformers/msmarco-distilroberta-base-v2',
          :minilm_6 => 'huggingface/sentence-transformers/all-MiniLM-L6-v2',
          :minilm_12 => 'huggingface/sentence-transformers/all-MiniLM-L12-v2',
          :mpnet => 'huggingface/sentence-transformers/all-mpnet-base-v',
          :multi_qa_minilm_6 => 'huggingface/sentence-transformers/multi-qa-MiniLM-L6-cos-v1',
          :multi_qa_mpnet => 'huggingface/sentence-transformers/multi-qa-mpnet-base-dot-v1',
          :paraphrase_minilm_3 => 'huggingface/sentence-transformers/paraphrase-MiniLM-L3-v2',
          :paraphrase_multilingual_minilm_12 => 'huggingface/sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2',
          :paraphrase_mpnet => 'huggingface/sentence-transformers/paraphrase-mpnet-base-v2',
          :multilingual_distiluse_cased => 'huggingface/sentence-transformers/distiluse-base-multilingual-cased-v1'
        }
      }

      cattr_reader :client do 
        Stretchy.configuration.client.ml
      end

      class << self
        include Errors
        # delegate :find, :status, :deployed?, :registered?, :task_id, :deploy_id, :model_id, :register, :deploy, :undeploy, :delete, to: :model

        METHODS = [
                    :model,
                    :group_id, 
                    :version, 
                    :description, 
                    :model_format, 
                    :enabled, 
                    :connector_id, 
                    :connector, 
                    :function_name, 
                    :model_config, 
                    :model_content_hash_value, 
                    :url  
                  ]

        def settings
          @settings ||= {}
        end

        METHODS.each do |method|
          define_method(method) do |args = nil|
            return settings[method] unless args.present?
            settings[method] = args

            if method == :connector
              connector_class = "#{args.to_s.camelize}".constantize
              settings[:connector] = connector_class
              # raise ConnectorMissingError if connector_class.id.nil?
              settings[:connector_id] = connector_class.id
            end

            if method == :model
              settings[:model] = model_lookup(args)
            end
          end
        end

        def model_id
          @model_id || registry.model_id
        end

        def task_id
          @task_id || registry.register_task_id
        end

        def deploy_id
          @deploy_id || registry.deploy_task_id
        end


        def registry
          @registry ||= Stretchy::MachineLearning::Registry.register(class_name: self.name, class_type: 'model')
        end

        def register
          begin
  
            response = client.register(body: self.to_hash, deploy: true)
  
            @task_id = response['task_id']
  
            self.registry.update(register_task_id: @task_id)
  
            yield self if block_given? 
  
            registered?
            self.registry.update(model_id: @model_id) 
            @model_id
          rescue => e
            Stretchy.logger.error "Error registering model: #{e.message}"
            false
          end
          true
        end

        def registered?
          return false unless task_id
          response = status
          @model_id = response['model_id'] if response['model_id']
          response['state'] == 'COMPLETED' && @model_id.present?
        end
  
        def status
          client.get_status(task_id: self.task_id)
        end


        def deploy
          @deployed = nil

          @deploy_id = client.deploy(id: self.model_id)['task_id']
          self.registry.update(deploy_task_id: @deploy_id)
          yield self if block_given? 
          @deploy_id
        end
  
        def undeploy
          @deployed = nil
          response = client.undeploy(id: self.model_id)
          self.registry.update(deploy_task_id: nil)
          yield self if block_given? 
          response
        end
  
        def deployed?
          return @deployed if @deployed
          response = client.get_model(id: self.model_id)
          # raise "Model not deployed" if response['model_state'] == 'FAILED'
          @deployed = response['model_state'] == 'DEPLOYED'
        end
  
        def delete
          self.registry.delete
          client.delete_model(id: self.model_id)
        end

        def find 
          begin
            client.get_model(id: self.model_id)
          rescue "#{Stretchy.configuration.search_backend_const}::Transport::Transport::Errors::InternalServerError".constantize => e
            raise Stretchy::MachineLearning::Errors::ModelMissingError
          end
        end

        def model_name(model_name = nil)
          @model_name = model_name if model_name
          @model_name || to_s.demodulize.underscore 
        end
  
        def to_hash
          {
            name: self.model || self.model_name,
            model_group_id: self.group_id,
            version: self.version,
            description: self.description,
            model_format: self.model_format,
            is_enabled: self.enabled?,
            connector_id: self.connector.present? ? self.connector.id : nil,
            function_name: self.function_name
          }.compact
        end
  
        def enabled?
          self.enabled
        end
  
        def wait_until_complete(max_attempts: 20, sleep_time: 4)
          attempts = 0
          loop do
            result = yield
            break if result
            attempts += 1
            break if attempts >= max_attempts
            sleep(sleep_time)
          end
        end

        def all
          client.get_model
        end

        def ml_on_all_nodes!
          settings = {
            "persistent": {
              "plugins": {
                "ml_commons": {
                  "only_run_on_ml_node": "false",
                  "model_access_control_enabled": "true",
                  "native_memory_threshold": "99"
                }
              }
            }
          }
          Stretchy.configuration.client.cluster.put_settings body: settings
        end

        def ml_on_ml_nodes!
          settings = {
            "persistent": {
              "plugins": {
                "ml_commons": {
                  "only_run_on_ml_node": "true",
                  "model_access_control_enabled": "true",
                  "native_memory_threshold": "99"
                }
              }
            }
          }
          Stretchy.configuration.client.cluster.put_settings body: settings
        end

        def model_lookup(model)
          @flattened_models ||= PRETRAINED_MODELS.flat_map do |key, value|
            value.map do |sub_key, sub_value|
              ["#{key}_#{sub_key}".to_sym, sub_value]
            end
          end.to_h

          @flattened_models[model.to_sym] || model.to_s
        end
      end


    end
  end
end