require "spec_helper"
require "models/post"

describe Stretchy::Repository do
  subject(:repository) { Post.gateway }

  before do
    repository.create_index!(force: true)
  end

  after do
    repository.delete_index!(force: true)
  end

  describe '#save' do
    it 'indexes the document under its id without a document type' do
      response = repository.save(id: '1', title: 'hello')
      expect(response['_id']).to eq('1')
      expect(response).not_to have_key('_type')
    end
  end

  describe '#find' do
    before do
      repository.save(id: '1', title: 'hello')
      repository.save(id: '2', title: 'goodbye')
    end

    it 'finds one document as a record' do
      post = repository.find('1')
      expect(post).to be_a(Post)
      expect(post.id).to eq('1')
      expect(post.title).to eq('hello')
    end

    it 'finds many documents, returning nil for missing ids' do
      expect(repository.find('1', '2', 'missing').map { |post| post&.title }).to eq(['hello', 'goodbye', nil])
    end

    it 'finds many documents from an Array' do
      expect(repository.find(['1']).map(&:title)).to eq(['hello'])
    end

    it 'raises RecordNotFound for a missing id' do
      expect { repository.find('missing') }.to raise_error(Stretchy::Errors::RecordNotFound)
    end
  end

  describe '#exists?' do
    it 'reports whether a document exists' do
      repository.save(id: '1', title: 'hello')
      expect(repository.exists?('1')).to be(true)
      expect(repository.exists?('missing')).to be(false)
    end
  end

  describe '#update' do
    it 'partially updates a document by id' do
      repository.save(id: '1', title: 'hello', body: 'world')
      repository.update('1', doc: { title: 'goodbye' })
      expect(repository.find('1').body).to eq('world')
      expect(repository.find('1').title).to eq('goodbye')
    end
  end

  describe '#delete' do
    it 'deletes a document by id' do
      repository.save(id: '1', title: 'hello')
      expect(repository.delete('1')['result']).to eq('deleted')
    end
  end

  describe '#search and #count' do
    before do
      repository.save(id: '1', title: 'hello')
      repository.save(id: '2', title: 'goodbye')
      repository.refresh_index!
    end

    it 'returns results wrapping records with the total' do
      results = repository.search(query: { term: { title: 'hello' } })
      expect(results).to be_a(Stretchy::Repository::Results)
      expect(results.total).to eq(1)
      expect(results.map(&:title)).to eq(['hello'])
      expect(results.response.hits.total.value).to eq(1)
    end

    it 'searches with a query string' do
      expect(repository.search('title:goodbye').map(&:id)).to eq(['2'])
    end

    it 'counts matching documents' do
      expect(repository.count).to eq(2)
      expect(repository.count(query: { term: { title: 'hello' } })).to eq(1)
    end

    it 'rejects unsupported search definitions' do
      expect { repository.search(1) }.to raise_error(ArgumentError)
    end
  end

  describe 'index management' do
    it 'creates the index with the model mappings and settings' do
      expect(repository.index_exists?).to be(true)
      mappings = repository.client.indices.get_mapping(index: repository.index_name)
      expect(mappings.dig(repository.index_name, 'mappings', 'properties', 'title', 'type')).to eq('keyword')
    end

    it 'ignores a missing index only when forced' do
      repository.delete_index!
      expect { repository.delete_index!(force: true) }.not_to raise_error
      expect { repository.delete_index! }.to raise_error(Stretchy.configuration.search_backend_const::Transport::Transport::Errors::NotFound)
    end
  end
end
