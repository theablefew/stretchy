require 'support/configurable'

shared_examples 'a stretchy model' do |model_class|
  # it_behaves_like 'configurable', model_class

  it 'responds to attributes' do
    expect(model_class.new).to respond_to(:attributes)
  end

  it 'has an index name' do
    expect(model_class.index_name).to eq(model_class.model_name.collection.parameterize.underscore)
  end

  it 'includes Stretchy::Associations' do
    expect(model_class).to include(Stretchy::Associations)
  end

  it 'includes Stretchy::Model::Refreshable' do
      expect(model_class).to include(Stretchy::Model::Refreshable)
  end

  it 'counts' do
    allow_any_instance_of(Elasticsearch::Persistence::Repository).to receive(:count).and_return(2)
    allow_any_instance_of(Elasticsearch::Persistence::Repository::Search).to receive(:count).and_return(2)
    expect(model_class.count).to be_a(Numeric)
  end

  context 'pipelines' do
    it 'responds to default_pipeline' do
      expect(model_class).to respond_to(:default_pipeline)
    end

    it 'can set a default_pipeline' do
      model_class.default_pipeline :test_pipeline
      expect(model_class.default_pipeline).to eq('test_pipeline')
    end

  end

  context 'defaults' do
    context 'attributes' do
      it 'includes an id' do
        expect(model_class.new).to respond_to(:id)
      end

      it 'is assigned an id on create' do
        expect(model_class.create.id).to be_a(String)
      end

      it 'includes created_at and updated_at' do
        expect(model_class.new).to respond_to(:created_at)
        expect(model_class.new).to respond_to(:updated_at)
      end
    end

    context 'sort key' do
      it 'defaults to created_at' do
        expect(model_class.default_sort_key).to eq(:created_at)
      end

      it 'can be overridden' do
        model_class.default_sort_key :updated_at
        expect(model_class.default_sort_key).to eq(:updated_at)
      end
    end

    context 'size' do
      it 'defaults to 10000' do
        expect(model_class.default_size).to eq(10000)
      end
  
      it 'can be overridden' do
        model_class.default_size 100
        expect(model_class.default_size).to eq(100)
      end
    end

  end 

  context 'attributes' do

    it 'accesses attributes[]' do
      model_class.attribute :testing_title, :text
      expect(model_class.new(testing_title: "hello")[:testing_title]).to eq("hello")
    end

    it 'accesses attributes[]=' do
      model_class.attribute :testing_title, :text
      record = model_class.new
      record[:testing_title] = "hello"
      expect(record[:testing_title]).to eq("hello")
    end

  end

  context 'inspection' do
  
    it 'shows class attributes' do
      # "#<#{self.name} #{attribute_types.map { |k,v| "#{k}: #{v.type}" }.join(', ')}>"
      expect(model_class.inspect).to eq("#<#{model_class.name} #{model_class.attribute_types.map { |k,v| "#{k}: #{v.type}" }.join(', ')}>")
    end

  end

  context 'named scopes' do
    it 'can receive a named scope' do
      expect(model_class).to respond_to(:scope)
      model_class.class_eval do
        attribute :test_status, :keyword
        scope :active, -> { where(test_status: 'active') }
      end
      expect(model_class).to respond_to(:active)
    end

    it 'can chain scopes' do
      model_class.class_eval do
        attribute :test_status, :keyword
        scope :inactive, -> { where(test_status: 'inactive') }
        scope :active, -> { where(test_status: 'active') }
      end
      expect(model_class.active.inactive).to be_a(Stretchy::Relation)
    end
  end

  context 'relation' do
    it 'builds queries' do
      expect(model_class.where(title: 'Across the Globe').to_elastic).to eq({"query"=>{"bool"=>{"must"=>{"term"=>{"title"=>"Across the Globe"}}}}})
    end
    
    it 'fetches results at end of chain' do
      allow_any_instance_of(Elasticsearch::Persistence::Repository).to receive(:search).and_return(
      Elasticsearch::Persistence::Repository::Response::Results.new(described_class.gateway, {
        "took": 688,
        "timed_out": false,
        "_shards": {
          "total": 1,
          "successful": 1,
          "skipped": 0,
          "failed": 0
        },
        "hits" => {
          "hits" => [
          ]
        }
      }))
      allow(model_class).to receive(:fetch_results).and_call_original
      model_class.all.size(10).inspect
      expect(model_class).to have_received(:fetch_results).once
    end

    it 'returns a relation' do
      expect(model_class.all.class.superclass).to eq(Stretchy::Relation)
    end

    it 'returns as json' do
      allow(model_class).to receive(:fetch_results).and_return([model_class.new])
      expect(model_class.all.as_json).to be_a(Array)
      expect(model_class.all.as_json.first).to be_a(Hash)
    end
  
    it 'builds a record from a relation' do
      model_class.attribute :test_title, :string
      expect(model_class.all.build(test_title: 'neat')).to be_a(model_class)
    end

    context 'counting' do
      it 'counts' do
        expect_any_instance_of(Stretchy::Relation).to receive(:count!).and_return(1)
        expect(model_class.where(name: 'hello').count).to be_a(Numeric)
      end

      it 'counts results with limit' do
        allow_any_instance_of(Stretchy::Relation).to receive(:results).and_return([described_class.new(id: '1'), described_class.new(id: '2')]) 
        expect_any_instance_of(Stretchy::Relation).not_to receive(:count!)
        expect(model_class.where(name: 'hello').limit(2).count).to eq(2)
      end


    end
  
    it 'plucks' do
      allow_any_instance_of(Stretchy::Relation).to receive(:to_a).and_return([model_class.new(id: 'goat'), model_class.new(id: 'cat')])
    
      expect(model_class.all.pluck(:id)).to be_a(Array)
      expect(model_class.all.pluck(:id)).to eq(['goat', 'cat'])
    end
  end

  context 'bulk' do
    context '.bulk_in_batches' do

      it 'yields batches' do
        allow(model_class).to receive(:bulk).and_return({ "errors" => false, "items" => [], "took" => 1})
        records = [model_class.new, model_class.new, model_class.new, model_class.new]
        expect { |b| model_class.bulk_in_batches(records, size: 2, &b) }.to yield_successive_args([records[0], records[1]], [records[2], records[3]])
      end

      it 'sends batch to bulk and refreshes index' do
        allow(model_class).to receive(:bulk).and_return({ "errors" => false, "items" => [], "took" => 1})
        allow(model_class).to receive(:refresh_index!)
        records = [model_class.new, model_class.new, model_class.new, model_class.new]
        model_class.bulk_in_batches(records, size: 2) do |batch|
          batch.map! { |record| record.to_bulk(:index) }
        end
        expect(model_class).to have_received(:bulk).twice
        expect(model_class).to have_received(:refresh_index!).once
      end

    end

    context '.to_bulk' do
      shared_examples 'a bulk operation' do |action, required_keys = [:_index]|
        let(:bulk) { record.to_bulk(action) }
    
        it 'has required keys' do
          expect(bulk).to have_key(action.to_sym)
          expect(bulk[action.to_sym].keys).to include(*required_keys)
          expect(bulk[action.to_sym][:_index]).to eq(model_class.index_name)
        end
      end
    
      context 'with index action' do
        let(:record) { model_class.new }
        it_behaves_like 'a bulk operation', :index, [:_index, :data]
    
        it 'has correct data keys' do
          record = model_class.new
          bulk = record.to_bulk
          expect(bulk[:index][:data].keys).to eq(record.attributes.keys)
        end
      end
    
      context 'with update action' do
        let(:record) { model_class.new(id: '123') }
        it_behaves_like 'a bulk operation', :update, [:_index, :_id, :data]
    
        it 'has correct id and data keys' do
          bulk = record.to_bulk(:update)
          expect(bulk[:update][:_id]).to eq(record.id)
          expect(bulk[:update][:data][:doc].keys).to eq(record.attributes.keys)
        end
      end
    
      context 'with delete action' do
        let(:record) { model_class.new(id: '123') }
        it_behaves_like 'a bulk operation', :delete, [:_index, :_id]
    
        it 'has correct id and no data key' do
          bulk = record.to_bulk(:delete)
          expect(bulk[:delete][:_id]).to eq(record.id)
          expect(bulk[:delete].keys).not_to include(:data)
        end
      end
    end

  end

end

shared_examples 'CRUD' do |model_class, attributes, update_with|

    
    it 'creates' do
      document = model_class.create(attributes)
      expect(document.id).not_to be_nil 
    end

    it 'saves' do
      document = model_class.new(attributes)
      document.save
      expect(document.id).not_to be_nil 
    end

    it 'deletes' do
      document = model_class.create(attributes)
      expect(document.delete).to be_truthy
    end

    it 'updates' do
      document = model_class.create(attributes)

      attribute = update_with.keys.first
      value = update_with.values.first
      document.update(update_with)
      expect(document.send(attribute.to_sym)).to eq(value)
      expect(model_class.last.send(attribute.to_sym)).to eq(value)
    end

    it 'refreshes index after save' do
      document = model_class.new(attributes)
      expect(document).to receive(:refresh_index)
      document.save
    end

    it 'refreshes index after destroy' do
      document = model_class.create(attributes)
      expect(document).to receive(:refresh_index)
      document.destroy
    end


end
