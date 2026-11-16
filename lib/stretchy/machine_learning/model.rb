require 'stretchy/machine_learning/errors'

module Stretchy 
  module MachineLearning
    class Model
      include Resource

      self.registry_type = 'model'

      settings :model,
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

      class << self
        include Errors
        # delegate :find, :status, :deployed?, :registered?, :task_id, :deploy_id, :model_id, :register, :deploy, :undeploy, :delete, to: :model

        # The pretrained model path for a known key such as `:sentence_transformers_minilm_12`, or the given name.
        def model(model = nil)
          return super() if model.nil?
          super(model_lookup(model))
        end

        def connector(connector = nil)
          return super() if connector.nil?
          connector_class = connector.to_s.camelize.constantize
          connector_id(connector_class.id)
          super(connector_class)
        end

        def model_id
          remote_id
        end

        def task_id
          @task_id || registry.register_task_id
        end

        def deploy_id
          @deploy_id || registry.deploy_task_id
        end

        # Registers the model, recording the register task. Returns false and logs when the request fails.
        def register
          response = client.register_model(body: to_hash)
          @task_id = response['task_id']
          registry.update(register_task_id: @task_id)

          yield self if block_given?

          self.remote_id = @remote_id if registered?
          true
        rescue => e
          Stretchy.logger.error "Error registering model: #{e.message}"
          false
        end

        def registered?
          return false unless task_id
          response = status
          @remote_id = response['model_id'] if response['model_id']
          response['state'] == 'COMPLETED' && @remote_id.present?
        end

        def status
          client.get_task(task_id: task_id)
        end

        def deploy
          @deploy_id = client.deploy_model(model_id: model_id)['task_id']
          registry.update(deploy_task_id: @deploy_id)
          yield self if block_given?
          @deploy_id
        end

        def undeploy
          response = client.undeploy_model(model_id: model_id)
          registry.update(deploy_task_id: nil)
          yield self if block_given?
          response
        end

        def deployed?
          find['model_state'] == 'DEPLOYED'
        rescue ModelMissingError
          false
        end

        # Deletes the remote model, then forgets it in the registry.
        def delete
          response = client.delete_model(model_id: model_id)
          registry.delete
          reset_remote_id!
          response
        end

        def find
          raise ModelMissingError if model_id.blank?
          client.get_model(model_id: model_id)
        rescue Stretchy.configuration.backend.not_found_error
          raise ModelMissingError
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
          client.search_models(body: { query: { match_all: {} } })
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