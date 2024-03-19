require 'spec_helper'

describe Stretchy::MachineLearning::Model do

  let(:backend) { Stretchy.configuration.opensearch? ? OpenSearch : Elasticsearch }

  it 'should have a client' do
    expect(Stretchy::MachineLearning::Model.client).to be_a("#{backend}::API::MachineLearning::Models::MachineLearningClient".constantize)
  end

  it 'should lookup a model' do
    expect(described_class.model_lookup :neural_sparse_encoding).to eq('amazon/neural-sparse/opensearch-neural-sparse-encoding-v1')
  end

  context 'model name' do
    it 'should have a model name' do
      model = described_class.new(model: 'great-model')
      expect(model.model).to eq('great-model')
    end
    
    it 'should lookup short names' do
      model = described_class.new model: :neural_sparse_encoding
      expect(model.model).to eq('amazon/neural-sparse/opensearch-neural-sparse-encoding-v1')
    end

  end

  context 'api' do
    let(:model) {  
      described_class.new(
        model: :neural_sparse_encoding, 
        version: '1.0.1', 
        model_format: 'TORCH_SCRIPT', 
        description: 'A great model'
      )
    }

    let(:status_complete) {
      {
        "model_id": "Qr1YbogBYOqeeqR7sI9L",
        "task_type": "DEPLOY_MODEL",
        "function_name": "TEXT_EMBEDDING",
        "state": "COMPLETED",
        "worker_node": [
          "N77RInqjTSq_UaLh1k0BUg"
        ],
        "create_time": 1685478486057,
        "last_update_time": 1685478491090,
        "is_async": true
      }.with_indifferent_access
    }

    context 'settings' do
      it 'runs ml on all nodes' do
        expect(described_class.ml_on_all_nodes!).to eq({"acknowledged"=>true, "persistent"=>{"plugins"=>{"ml_commons"=>{"only_run_on_ml_node"=>"false", "model_access_control_enabled"=>"true", "native_memory_threshold"=>"99"}}}, "transient"=>{}}.with_indifferent_access)
      end

      it 'runs ml on ml nodes' do
        expect(described_class.ml_on_ml_nodes!).to eq({"acknowledged"=>true, "persistent"=>{"plugins"=>{"ml_commons"=>{"only_run_on_ml_node"=>"true", "model_access_control_enabled"=>"true", "native_memory_threshold"=>"99"}}}, "transient"=>{}}.with_indifferent_access)
      end
    end


    context 'register' do
      before(:each) do
        allow(model.client).to receive(:register).and_return({task_id: '123456', status: "CREATED"}.with_indifferent_access)
        allow(model.client).to receive(:get_status).and_return(status_complete)
      end

      it 'should register and return the task id' do
        expect(model.register).to be_truthy
        expect(model.task_id).to eq('123456')
      end

      it 'should register and wait until complete' do
        model.register do |model|
          model.wait_until_complete do
            response = model.status
            model.instance_variable_set(:@model_id, response['model_id'])
            response['state'] == 'COMPLETED'
          end
        end
        expect(model.task_id).to eq('123456')
        expect(model.model_id).to eq('Qr1YbogBYOqeeqR7sI9L')
      end
    end

    context 'status' do
      before(:each) do
        allow(model.client).to receive(:register).and_return({task_id: '123456', status: "CREATED"}.with_indifferent_access)
        allow(model.client).to receive(:get_status).and_return(status_complete)

      end

      it 'should get the status' do
        model.register
        expect(model.status).to eq(status_complete)
        expect(model.status[:state]).to eq('COMPLETED')
      end

    end

    context 'deploy' do
      let(:status_deploying) {{"model_state": "DEPLOYING"}.with_indifferent_access }
      let(:status_deployed) { {"model_state": "DEPLOYED"}.with_indifferent_access }

      before(:each) do
        allow(model).to receive(:model_id).and_return('Qr1YbogBYOqeeqR7sI9L')
        allow(model.client).to receive(:deploy).with(id: 'Qr1YbogBYOqeeqR7sI9L')
          .and_return({task_id: '78910', status: "DEPLOYING"}.with_indifferent_access)
      end

      it 'should deploy' do
        expect(model.deploy).to be_truthy
        expect(model.deploy_id).to eq('78910')
      end

      it 'should check if deployed' do
        allow(model).to receive(:model_id).and_return('78910')
        allow(model.client).to receive(:get_model).with(id: '78910').and_return(status_deployed)
        expect(model.deployed?).to be_truthy
      end

      context 'not deployed' do
        it 'should check if deployed' do
          allow(model).to receive(:model_id).and_return('78910')
          allow(model.client).to receive(:get_model).with(id: '78910').and_return(status_deploying)
          expect(model.deployed?).to be_falsey
        end
      end
 
    end

    context 'undeploy' do

      let(:undeploy_response) {
        {
          "sv7-3CbwQW-4PiIsDOfLxQ": {
            "stats": {
              "Qr1YbogBYOqeeqR7sI9L": "UNDEPLOYED"
            }
          }
        }
      }

      it 'should undeploy' do
        allow(model).to receive(:model_id).and_return('Qr1YbogBYOqeeqR7sI9L')
        allow(model.client).to receive(:undeploy).with(id: 'Qr1YbogBYOqeeqR7sI9L').and_return(undeploy_response)
        expect(model.undeploy).to eq(undeploy_response)
      end
    end

    context 'delete' do
      let(:delete_response) {
        {
          "_index": ".plugins-ml-model",
          "_id": "Qr1YbogBYOqeeqR7sI9L",
          "_version": 2,
          "result": "deleted",
          "_shards": {
            "total": 2,
            "successful": 2,
            "failed": 0
          },
          "_seq_no": 27,
          "_primary_term": 18
        }
      }

      it 'should delete' do
        allow(model).to receive(:model_id).and_return('Qr1YbogBYOqeeqR7sI9L')
        allow(model.client).to receive(:delete_model).with(id: 'Qr1YbogBYOqeeqR7sI9L').and_return(delete_response)
        expect(model.delete).to eq(delete_response)
      end
    end

    context 'find' do
      let(:model_response) {
        {
          "Qr1YbogBYOqeeqR7sI9L": {
            "model": "neural_sparse_encoding",
            "model_group_id": "neural_sparse",
            "version": "1.0.1",
            "description": "A great model",
            "model_format": "TORCH_SCRIPT",
            "is_enabled": true
          }
        }
      }

      it 'should find' do
        allow(model).to receive(:model_id).and_return('Qr1YbogBYOqeeqR7sI9L')
        allow(model.client).to receive(:get_model).with(id: 'Qr1YbogBYOqeeqR7sI9L').and_return(model_response)
        expect(model.find).to eq(model_response)
      end
    end
  
    context 'all' do
      let(:all_response) {
        {
          "took": 8,
          "timed_out": false,
          "_shards": {
            "total": 1,
            "successful": 1,
            "skipped": 0,
            "failed": 0
          },
          "hits": {
            "total": {
              "value": 2,
              "relation": "eq"
            },
            "max_score": 2.4159138,
            "hits": [
              {
                "_index": ".plugins-ml-model",
                "_id": "-QkKJX8BvytMh9aUeuLD",
                "_version": 1,
                "_seq_no": 12,
                "_primary_term": 15,
                "_score": 2.4159138,
                "_source": {
                  "name": "FIT_RCF",
                  "version": 1,
                  "content": "xxx",
                  "algorithm": "FIT_RCF"
                }
              }
            ]
          }
        }
      }

      it 'should list all models' do
        allow(model.client).to receive(:get_model).and_return(all_response)
        expect(described_class.all).to eq(all_response)
      end
    end
  end


end