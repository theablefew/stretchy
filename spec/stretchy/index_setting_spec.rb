require 'spec_helper'

describe Stretchy::IndexSetting do
  describe 'class methods' do
    it 'responds to analyzer' do
      expect(described_class).to respond_to(:analyzer)
    end

    it 'responds to filter' do
      expect(described_class).to respond_to(:filter)
    end

    it 'responds to tokenizer' do
      expect(described_class).to respond_to(:tokenizer)
    end

    it 'responds to normalizer' do
      expect(described_class).to respond_to(:normalizer)
    end

    let(:subject) do
      Analysis = Class.new(Stretchy::IndexSetting) do
        analyzer :default, filter: [:lowercase], tokenizer: :standard

        analyzer :path_analyzer,
          filter: [
            :lowercase,
            :asciifolding
          ],
          type: :custom,
          tokenizer: :path_tokenizer

        filter :lowercase, type: :lowercase

        tokenizer :standard, type: :standard

        normalizer :default, filter: [:lowercase], tokenizer: :standard
      end
    end
    it 'returns settings as_json' do

      expect(subject.as_json).to eq(
        {
          analysis: {
            analyzer: {
              default: { filter: [:lowercase], tokenizer: :standard },
              path_analyzer: 
                { filter: [:lowercase, :asciifolding], type: :custom, tokenizer: :path_tokenizer }
            },
            filter: {
              lowercase: { type: :lowercase }
            },
            tokenizer: {
              standard: { type: :standard }
            },
            normalizer: {
              default: { filter: [:lowercase], tokenizer: :standard }
            }
          }
        }
      )

    end

    context 'collection' do
      it 'returns the analyzers' do
        described_class.analyzer(:default, filter: [:lowercase], tokenizer: :standard)
        expect(described_class.analyzers).to eq({ default: { filter: [:lowercase], tokenizer: :standard } })
      end

      it 'returns the filters' do
        described_class.filter(:lowercase, type: :lowercase)
        expect(described_class.filters).to eq({ lowercase: { type: :lowercase } })
      end

      it 'returns the tokenizers' do
        described_class.tokenizer(:standard, type: :standard)
        expect(described_class.tokenizers).to eq({ standard: { type: :standard } })
      end
    
      it 'returns the normalizers' do
        described_class.normalizer(:default, filter: [:lowercase], tokenizer: :standard)
        expect(described_class.normalizers).to eq({ default: { filter: [:lowercase], tokenizer: :standard } })
      end
    end
  end
end