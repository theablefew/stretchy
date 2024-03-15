require 'spec_helper'

describe Stretchy::Attributes do
  
  it 'array type is registered' do
    expect(ActiveModel::Type.lookup(:array).type).to eq(:array)
  end

  it 'hash type is registered' do
    expect(ActiveModel::Type.lookup(:hash).type).to eq(:hash)
  end

  it 'keyword type is registered' do
    expect(ActiveModel::Type.lookup(:keyword).type).to eq(:keyword)
  end

  it 'text type is registered' do
    expect(ActiveModel::Type.lookup(:text).type).to eq(:text)
  end

  context 'in model' do
    let(:model) do
      Object.send(:remove_const, :AttributeModel) if Object.const_defined?(:AttributeModel)
      stub_const("AttributeModel", Class.new(Stretchy::Record) do
        attribute :name, :text
        attribute :age, :integer 
        attribute :tags, :array
        attribute :data, :hash, properties: {weights: {type: :integer}, biases: {type: :integer}}
        attribute :flagged, :boolean, default: false
        attribute :body, :text
        attribute :only_text, :text, fields: false
      end)
    end

    context 'hash' do
      it 'cast_value' do
        expect(model.attribute_types['data'].cast({})).to be_a Elasticsearch::Model::HashWrapper
      end
    end


    context 'mappings' do


      context 'auto keyword fields for text fields' do
        it 'adds keyword to text fields' do
          expect(model.attribute_mappings['properties']['body']).to eq({type: :text, fields: {keyword: {type: :keyword, ignore_above: 256}}}.as_json)
        end

        it 'does not add keyword to text fields when fields is false' do
          expect(model.attribute_mappings['properties']['only_text']).to eq({type: :text}.as_json)
        end

        it 'does not add keyword to text fields when fields is present' do
          model.attribute :location, :text, fields: {raw: {type: :keyword}}
          expect(model.attribute_mappings['properties']['location']).to eq({type: :text, fields: {raw: {type: :keyword}}}.as_json)
        end

        let(:mapping) do
          { 
          "attribute_models": { 
            "mappings": { 
              "dynamic": true,
              "properties": { 
                "age": { 
                  "type": "integer"
                },
                "body": { 
                  "type": "text",
                  "fields": { 
                    "keyword": { 
                      "type": "keyword",
                      "ignore_above": 256
                    }
                  }
                },
                "created_at": { 
                  "type": "date"
                },
                "data": { 
                  "properties": { 
                    "biases": { 
                      "type": "integer"
                    },
                    "weights": { 
                      "type": "integer"
                    }
                  }
                },
                "flagged": { 
                  "type": "boolean"
                },
                "id": { 
                  "type": "keyword"
                },
                "name": { 
                  "type": "text",
                  "fields": { 
                    "keyword": { 
                      "type": "keyword",
                      "ignore_above": 256
                    }
                  }
                },
                "only_text": { 
                  "type": "text"
                },
                "tags": { 
                  "type": "text",
                  "fields": { 
                    "keyword": { 
                      "type": "keyword",
                      "ignore_above": 256
                    }
                  }
                },
                "updated_at": { 
                  "type": "date"
                }
              }
            }
          }
        }.with_indifferent_access
        end

        it 'creates index with attribute mappings' do
          model.delete_index! if model.index_exists?
          model.create_index!
          # ap model.mappings.as_json
          # ap mapping[:attribute_models][:mappings][:properties].as_json
          expect(model.mappings.with_indifferent_access[:properties].as_json).to eq(mapping[:attribute_models][:mappings][:properties])
        end

      end


    end
  end

end