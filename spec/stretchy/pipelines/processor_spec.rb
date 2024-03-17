require 'spec_helper'

describe Stretchy::Pipelines::Processor do
  describe '#initialize' do
    it 'sets the type, opts, and description' do
      type = 'set'
      opts = { description: 'some description' }
      processor = described_class.new(type, opts)

      expect(processor.type).to eq(type)
      expect(processor.opts).to eq(opts)
      expect(processor.description).to eq(opts[:description])
    end
  end

  describe '#to_hash' do
    it 'returns a hash representation of the processor' do
      type = 'some_type'
      opts = {model_id: 'q32Pw02BJ3squ3VZa',
        field_map: {
          body: :embedding
        }
      }
      processor = described_class.new(type, opts)

      expected_hash = { type => opts }
      expect(processor.to_hash).to eq(expected_hash)
    end
  end
end