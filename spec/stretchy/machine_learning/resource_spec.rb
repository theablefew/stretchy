require 'spec_helper'

describe Stretchy::MachineLearning::Resource do
  let(:resource) do
    Class.new do
      include Stretchy::MachineLearning::Resource
      self.registry_type = 'widget'
      settings :description, :version, :enabled

      def self.name
        'TestWidget'
      end
    end
  end

  context 'settings' do
    it 'reads and writes a declared setting' do
      resource.description 'A widget'
      expect(resource.description).to eq('A widget')
    end

    it 'stores false values' do
      resource.enabled false
      expect(resource.enabled).to be(false)
    end

    it 'builds nested settings from a block' do
      resource.version { major 1 }
      expect(resource.version.major).to eq(1)
    end

    it 'wraps Hash values for method access' do
      resource.description text: 'A widget'
      expect(resource.description.text).to eq('A widget')
    end

    it 'raises NoMethodError for an undeclared setting' do
      expect { resource.colour 'red' }.to raise_error(NoMethodError)
    end

    it 'keeps settings separate per class' do
      other = Class.new(resource)
      other.description 'Another widget'
      resource.description 'A widget'
      expect(other.description).to eq('Another widget')
    end
  end

  context 'remote id' do
    before(:each) do
      Stretchy::MachineLearning::Registry.delete_index! if Stretchy::MachineLearning::Registry.index_exists?
      resource.reset_remote_id!
    end

    it 'registers under the class name and registry type' do
      expect(resource.registry.class_name).to eq('TestWidget')
      expect(resource.registry.class_type).to eq('widget')
    end

    it 'stores the remote id in the registry' do
      resource.remote_id = 'abc123'
      resource.reset_remote_id!
      expect(resource.remote_id).to eq('abc123')
    end

    it 'reads ids stored in model_id before remote_id existed' do
      resource.registry.update(model_id: 'legacy')
      resource.reset_remote_id!
      expect(resource.remote_id).to eq('legacy')
    end
  end
end
