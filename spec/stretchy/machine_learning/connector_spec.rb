require 'spec_helper'

describe Stretchy::MachineLearning::Connector do

  let(:connector) do
    ClaudeConnector ||= Class.new(Stretchy::MachineLearning::Connector) do
      description "The connector to BedRock service for claude model"
    
      version 1
      
      protocol "aws_sigv4"
      
      credentials access_key: "<bedrock_access_key>",
                  secret_key: "<bedrock_secret_key>",
                  session_token: "<bedrock_session_token>"
      
      
      parameters region: "us-east-1",
                  service_name: "bedrock",
                  anthropic_version: "bedrock-2023-05-31",
                  endpoint: "bedrock.us-east-1.amazonaws.com",
                  auth: "Sig_V4",
                  content_type: "application/json",
                  max_tokens_to_sample: 8000,
                  temperature: 0.0001,
                  response_filter: "$.completion"
    
      actions action_type: "predict",
              method: "POST",
              url: "https://bedrock-runtime.us-east-1.amazonaws.com/model/anthropic.claude-v2/invoke",
              headers: {
                content_type: "application/json",
                x_amz_content_sha256: "required"
              },
              request_body: {
                  prompt: "${parameters.prompt}",
                  max_tokens_to_sample: "${parameters.max_tokens_to_sample}",
                  temperature: "${parameters.temperature}",
                  anthropic_version: "${parameters.anthropic_version}"
              }
    end
      
  end

  context 'settings' do
    context 'name' do
      it 'should have a default name' do
        expect(connector.name).to eq("claude_connector")
      end
    
      it 'should have a custom name' do
        connector.name "custom_name"
        expect(connector.name).to eq("custom_name")
      end
    end

    it 'should have a description' do
      expect(connector.description).to eq("The connector to BedRock service for claude model")
    end

    it 'should have a version' do
      expect(connector.version).to eq(1)
    end

    it 'should have a protocol' do
      expect(connector.protocol).to eq("aws_sigv4")
    end

    it 'should have credentials' do
      expect(connector.credentials).to eq(
        {
          access_key: "<bedrock_access_key>",
          secret_key: "<bedrock_secret_key>",
          session_token: "<bedrock_session_token>"
        }.with_indifferent_access 
      )
    end

    context 'parameters' do
      it 'should have parameters' do
        expect(connector.parameters.as_json).to eq({region: "us-east-1", service_name: "bedrock", anthropic_version: "bedrock-2023-05-31", endpoint: "bedrock.us-east-1.amazonaws.com", auth: "Sig_V4", content_type: "application/json", max_tokens_to_sample: 8000, temperature: 0.0001, response_filter: "$.completion"}.as_json)
      end
      
      it 'should have region' do
        expect(connector.parameters.region).to eq("us-east-1")
      end

      it 'should have service_name' do
        expect(connector.parameters.service_name).to eq("bedrock")
      end
    end

    context 'actions' do
      it 'should have actions' do
        expect(connector.actions.as_json).to eq({action_type: "predict", method: "POST", url: "https://bedrock-runtime.us-east-1.amazonaws.com/model/anthropic.claude-v2/invoke", headers: {content_type: "application/json", x_amz_content_sha256: "required"}, request_body: {prompt: "${parameters.prompt}", max_tokens_to_sample: "${parameters.max_tokens_to_sample}", temperature: "${parameters.temperature}", anthropic_version: "${parameters.anthropic_version}"}}.as_json)
      end

      it 'should have action_type' do
        expect(connector.actions.action_type).to eq("predict")
      end

      it 'should have method' do
        expect(connector.actions[:method]).to eq("POST")
      end

      it 'should have url' do
        expect(connector.actions.url).to eq("https://bedrock-runtime.us-east-1.amazonaws.com/model/anthropic.claude-v2/invoke")
      end

      context 'headers' do
        it 'should have headers' do
          expect(connector.actions.headers.as_json).to eq({content_type: "application/json", x_amz_content_sha256: "required"}.as_json)
        end

        it 'should have content_type' do
          expect(connector.actions.headers.content_type).to eq("application/json")
        end
      end

      context 'request_body' do
        it 'should have request_body' do
          expect(connector.actions.request_body.as_json).to eq({prompt: "${parameters.prompt}", max_tokens_to_sample: "${parameters.max_tokens_to_sample}", temperature: "${parameters.temperature}", anthropic_version: "${parameters.anthropic_version}"}.as_json)
        end

        it 'should have prompt' do
          expect(connector.actions.request_body[:prompt]).to eq("${parameters.prompt}")
        end
      end

    end
  end

  it 'should to_hash' do
    expect(connector.to_hash.as_json).to eq(
      {
        "name": "claude_connector",
        "description": "The connector to BedRock service for claude model",
        "version": 1,
        "protocol": "aws_sigv4",
        "credential": {
          "access_key": "<bedrock_access_key>",
          "secret_key": "<bedrock_secret_key>",
          "session_token": "<bedrock_session_token>"
        },
        "parameters": {
          "region": "us-east-1",
          "service_name": "bedrock",
          "anthropic_version": "bedrock-2023-05-31",
          "endpoint": "bedrock.us-east-1.amazonaws.com",
          "auth": "Sig_V4",
          "content_type": "application/json",
          "max_tokens_to_sample": 8000,
          "temperature": 0.0001,
          "response_filter": "$.completion"
        },
        "actions": [{
          "action_type": "predict",
          "method": "POST",
          "url": "https://bedrock-runtime.us-east-1.amazonaws.com/model/anthropic.claude-v2/invoke",
          "headers": {
            "content_type": "application/json",
            "x_amz_content_sha256": "required"
          },
          "request_body": {
            "prompt": "${parameters.prompt}",
            "max_tokens_to_sample": "${parameters.max_tokens_to_sample}",
            "temperature": "${parameters.temperature}",
            "anthropic_version": "${parameters.anthropic_version}"
        }
        }]
      }.as_json
    )

  end


  context 'api' do

    before(:each) do
      Stretchy::MachineLearning::Registry.delete_index! if Stretchy::MachineLearning::Registry.index_exists?
    end
    
    context 'exists' do
      it 'should return true if connector exists' do
        expect(connector.client).to receive(:get).and_return({"name": "BedRock Claude-Instant v1", "version": "1"})
        expect(connector.exists?).to eq(true)
      end

      it 'should return false if connector does not exist' do
        expect(connector.client).to receive(:get).and_return({})
        expect(connector.exists?).to eq(false)
      end
    end
    
    context 'create' do
      
      it 'should create a connector' do
        expect(connector.client).to receive(:post).and_return({"connector_id": "123456"})
        expect(connector.create!).to be_truthy
        expect(connector.id).to eq("123456")
      end

      context 'registry' do
        it 'should update registry' do
          expect(connector.client).to receive(:post).and_return({"connector_id": "123456"})
          expect(connector.create!).to be_truthy
          expect(connector.id).to eq("123456")
          expect(connector.registry.model_id).to eq("123456")
        end
      end

    end

    context 'find' do
      it 'should find a connector' do
        expect(connector.client).to receive(:get).and_return({"name": "BedRock Claude-Instant v1", "version": "1"})
        expect(connector.find).to eq({"name": "BedRock Claude-Instant v1", "version": "1"})
      end

      xit 'should raise an error if connector does not exist' do
        allow(connector).to receive(:id).and_return(1)
        expect(connector.client).to receive(:get).and_call_original
        expect { connector.find }.to raise_error(Stretchy::MachineLearning::Errors::ConnectorMissingError)
      end
    end

    context 'update' do
      it 'should update a connector' do
        expect(connector.client).to receive(:put).and_return({
          "_index": ".plugins-ml-connector",
          "_id": "u3DEbI0BfUsSoeNTti-1",
          "_version": 2,
          "result": "updated",
          "_shards": {
            "total": 1,
            "successful": 1,
            "failed": 0
          },
          "_seq_no": 2,
          "_primary_term": 1
        })
        expect(connector.update!).to be_truthy
      end
    end

    context 'delete' do
      let(:delete_response) {
        {
          "_index": ".plugins-ml-connector",
          "_id": "u3DEbI0BfUsSoeNTti-1",
          "_version": 2,
          "result": "deleted",
          "_shards": {
            "total": 1,
            "successful": 1,
            "failed": 0
          },
          "_seq_no": 2,
          "_primary_term": 1
        }
      }
      it 'should delete a connector' do
        registry_double = double('Registry', model_id: nil)
        allow(registry_double).to receive(:delete)
        allow(connector).to receive(:registry).and_return(registry_double)
        expect(connector.client).to receive(:delete).and_return(delete_response)
        expect(connector.delete!).to be_truthy
        expect(connector.id).to be_nil
      end

      context 'registry' do
        it 'should delete registry' do
          registry_double = double('Registry')
          allow(registry_double).to receive(:delete)
          allow(registry_double).to receive(:model_id).and_return(nil)
          allow(connector).to receive(:registry).and_return(registry_double)
          expect(connector.client).to receive(:delete).and_return(delete_response)
          expect(connector.delete!).to be_truthy
          expect(connector.id).to be_nil
          expect(connector.registry.model_id).to be_nil
        end
      end
    end

  end

end
