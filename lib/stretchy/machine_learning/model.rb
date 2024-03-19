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
        attr_accessor :model, :group_id 

        def all
          client.get_model
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

      attr_accessor :model,
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

      attr_reader :task_id, :model_id, :deploy_id

      def initialize(args = {})
        model_name = args.delete(:model)
        args.each do |k,v|
          self.send("#{k}=", v)
        end
        @model = self.class.model_lookup model_name
      end

      def register
        begin
          response = client.register(body: self.to_hash, deploy: true)

          @task_id = response['task_id']

          yield self if block_given? 

          @model_id
        rescue => e
          puts e
          false
        end
        true
      end

      def status
        response = client.get_status(task_id: self.task_id)
        
        response
      end

      def deploy
        @deployed = nil
        @deploy_id = client.deploy(id: self.model_id)['task_id']
        yield self if block_given? 
      end

      def undeploy
        @deployed = nil
        client.undeploy(id: self.model_id)
      end

      def deployed?
        return @deployed if @deployed
        response = client.get_model(id: self.model_id)
        Stretchy.logger.debug "Deployed? #{self.model_id} #{response}"
        # raise "Model not deployed" if response['model_state'] == 'FAILED'
        @deployed = response['model_state'] == 'DEPLOYED'
      end

      def delete
        client.delete_model(id: self.model_id)
      end

      def client
        @@client
      end

      def find 
        client.get_model(id: self.model_id)
      end

      def to_hash
        {
          name: self.model,
          model_group_id: self.group_id,
          version: self.version,
          description: self.description,
          model_format: self.model_format,
          is_enabled: self.enabled?
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


    end
  end
end