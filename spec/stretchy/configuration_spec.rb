require 'spec_helper'

describe Stretchy::Configuration do

    it 'has a default host' do
        client = Stretchy.configuration.client.transport.transport.hosts.first
        expect(client[:host]).to eq('localhost')
        expect(client[:port]).to eq(9200)
    end

    let(:model) do
        class TestModel < Stretchy::Record
        end
        TestModel
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