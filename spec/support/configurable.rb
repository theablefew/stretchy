require 'spec_helper'

shared_examples 'configurable' do |model|
    before(:all) do
        @original_config = Stretchy.configuration.client.dup
    end

    after(:all) do
        Stretchy.configure do |config|
             config.client = @original_config
        end
    end

    it 'has a default host' do
        client = Stretchy.configuration.client.transport.transport.hosts.first
        expect(client[:host]).to eq('localhost')
        expect(client[:port]).to eq(9200)
    end

    it 'can configure client' do
        Stretchy.configure do |config|
            config.client = Elasticsearch::Client.new url: 'http://localhost:92929'
        end

        expect(Stretchy.configuration.client.transport.transport.hosts.first[:host]).to eq('localhost')
        expect(Stretchy.configuration.client.transport.transport.hosts.first[:port]).to eq(92929)
        expect(model.gateway.client.transport.transport.hosts.first[:port]).to eq(92929)

    end
end