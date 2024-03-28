require 'spec_helper'

describe Stretchy::Configuration do
  
  before(:all) do
    @original_config = Stretchy.configuration.client.dup
  end

  after(:all) do
      Stretchy.configure do |config|
          config.client = @original_config
      end
  end

  context 'defaults' do
    it 'defaults to add keyword field to text attributes' do
        expect(Stretchy.configuration.add_keyword_field_to_text_attributes).to be(true)
    end

    it 'has a default keyword field' do
        expect(Stretchy.configuration.default_keyword_field).to eq(:keyword)
    end
  end

  it 'has a default host' do
      client = Stretchy.configuration.client.transport.transport.hosts.first
      expect(client[:host]).to eq('localhost')
      expect(client[:port]).to eq(9200)
  end

  it 'can configure client' do
    Stretchy.configure do |config|
        config.client = Elasticsearch::Client.new url: 'http://bocalbost:92929'
    end

    client = Stretchy.configuration.client.transport.transport.hosts.first
    expect(client[:host]).to eq('bocalbost')
    expect(client[:port]).to eq(92929)
  end


end