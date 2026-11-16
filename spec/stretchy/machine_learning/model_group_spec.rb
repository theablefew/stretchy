require 'spec_helper'

describe Stretchy::MachineLearning::ModelGroup, opensearch_only: true do
  let(:registry) { double('Registry', remote_id: nil, update: true, delete: true) }

  let(:group) do
    klass = Class.new(described_class) do
      description "Sentence embedding models"
      access_mode "public"
    end
    stub_const('Embeddings', klass)
  end

  before { allow(group).to receive(:registry).and_return(registry) }

  context 'settings' do
    it 'defaults the name to the underscored class name' do
      expect(group.to_hash).to eq(name: 'embeddings', description: 'Sentence embedding models', access_mode: 'public')
    end

    it 'accepts a custom name' do
      group.remote_name 'shared_embeddings'
      expect(group.to_hash[:name]).to eq('shared_embeddings')
    end
  end

  context 'register!' do
    it 'stores the group id in the registry' do
      expect(group.client).to receive(:register_model_group).with(body: group.to_hash).and_return('model_group_id' => 'grp-1', 'status' => 'CREATED')
      expect(registry).to receive(:update).with(remote_id: 'grp-1')
      group.register!
      expect(group.group_id).to eq('grp-1')
    end
  end

  context 'find' do
    it 'raises ModelGroupMissingError without a group id' do
      expect { group.find }.to raise_error(Stretchy::MachineLearning::Errors::ModelGroupMissingError)
    end

    it 'raises ModelGroupMissingError when the group is gone' do
      allow(group).to receive(:group_id).and_return('grp-1')
      allow(group.client).to receive(:get_model_group).and_raise(Stretchy.configuration.backend.not_found_error)
      expect(group.exists?).to be(false)
    end
  end

  context 'delete!' do
    it 'deletes the remote group before forgetting it' do
      allow(group).to receive(:group_id).and_return('grp-1')
      expect(group.client).to receive(:delete_model_group).with(model_group_id: 'grp-1').ordered.and_return('result' => 'deleted')
      expect(registry).to receive(:delete).ordered
      group.delete!
    end
  end

  context 'with a model' do
    it 'sends the group id in the register body' do
      group
      allow(group).to receive(:group_id).and_return('grp-1')
      embedding_model = Class.new(Stretchy::MachineLearning::Model) do
        model :sentence_transformers_minilm_12
        model_group :embeddings
      end
      expect(embedding_model.model_group).to eq(Embeddings)
      expect(embedding_model.to_hash[:model_group_id]).to eq('grp-1')
    end
  end
end
