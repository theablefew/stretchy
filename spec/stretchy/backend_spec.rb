require "spec_helper"

describe Stretchy::Backend do
  def client_named(name)
    instance_double(Object).tap { |client| allow(client).to receive_message_chain(:class, :name).and_return(name) }
  end

  describe '.for' do
    it 'selects OpenSearch for an OpenSearch client' do
      expect(described_class.for(client_named('OpenSearch::Client'))).to be_a(Stretchy::Backend::OpenSearch)
    end

    it 'selects Elasticsearch for any other client' do
      expect(described_class.for(client_named('Elasticsearch::Client'))).to be_a(Stretchy::Backend::Elasticsearch)
    end
  end

  describe Stretchy::Backend::Elasticsearch do
    subject(:backend) { described_class.new }

    it { expect(backend.namespace).to eq(::Elasticsearch) }
    it { expect(backend).not_to be_opensearch }
    it { expect(backend.not_found_error).to eq(::Elasticsearch::Transport::Transport::Errors::NotFound) }
    it { expect(backend.server_error).to eq(::Elasticsearch::Transport::Transport::Errors::InternalServerError) }
  end

  describe Stretchy::Backend::OpenSearch, opensearch_only: true do
    subject(:backend) { described_class.new }

    it { expect(backend.namespace).to eq(::OpenSearch) }
    it { expect(backend).to be_opensearch }
    it { expect(backend.not_found_error).to eq(::OpenSearch::Transport::Transport::Errors::NotFound) }
    it { expect(backend.server_error).to eq(::OpenSearch::Transport::Transport::Errors::InternalServerError) }
  end

  it 'is chosen from the configured client' do
    expected = ENV['BACKEND'] == 'opensearch' ? Stretchy::Backend::OpenSearch : Stretchy::Backend::Elasticsearch
    expect(Stretchy.configuration.backend).to be_a(expected)
  end
end
