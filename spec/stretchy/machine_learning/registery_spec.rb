require 'spec_helper'

describe Stretchy::MachineLearning::Registry do

  context 'index' do
    it 'should have an index' do
      Stretchy::MachineLearning::Registry.create_index!
      expect(Stretchy::MachineLearning::Registry.index_exists?).to be true
      expect(Stretchy::MachineLearning::Registry.index_name).to eq('.stretchy_ml_registry_test')
    end
  end

  context 'registers' do
    before(:each) do
      Stretchy::MachineLearning::Registry.delete_index! if Stretchy::MachineLearning::Registry.index_exists?
    end

    it 'should create the index' do
      allow(Stretchy::MachineLearning::Registry).to receive(:create_index!).and_call_original
      described_class.register(class_name: 'Stretchy::MachineLearning::Model')
      expect(Stretchy::MachineLearning::Registry).to have_received(:create_index!).once
      expect(Stretchy::MachineLearning::Registry.index_exists?).to be true
    end

    it 'finds or creates a model' do
      allow(Stretchy::MachineLearning::Registry).to receive(:create).and_call_original
      first_registry = described_class.register(class_name: 'Stretchy::MachineLearning::Model'.underscore)
      found = described_class.register(class_name: 'Stretchy::MachineLearning::Model'.underscore)
      expect(Stretchy::MachineLearning::Registry).to have_received(:create).once

      expect(found.id).to eq(first_registry.id)
    end

    it 'updates a model' do
      model = described_class.register(class_name: 'Stretchy::MachineLearning::Model')
      model.update(model_id: '1234')
      expect(described_class.find(model.id).model_id).to eq('1234')
    end

  end

end