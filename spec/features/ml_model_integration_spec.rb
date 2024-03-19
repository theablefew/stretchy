require 'spec_helper'

describe 'ML Model', opensearch_only: true do
  before(:all) do
    @sparse_model = Stretchy::MachineLearning::Model.new(
      model: :neural_sparse_encoding,
      version: '1.0.1',
      model_format: 'TORCH_SCRIPT',
      description: 'Creates sparse embedding for onboarding docs'
    )
    @sparse_model.register do |model|
      model.wait_until_complete do
        response = model.status
        Stretchy.logger.debug response
        model.instance_variable_set(:@model_id, response['model_id'])
        response['state'] == 'COMPLETED'
      end
    end

    @model_id = @sparse_model.model_id
    @sparse_model.deploy do |model|
      model.wait_until_complete(sleep_time: 5) do
        Stretchy.logger.debug "Deploying model #{model}"
        model.deployed?
      end
    end
  end

  let!(:sparse_model) { @sparse_model }

  let(:sparse_pipeline) do
    model_id = sparse_model.model_id
    NLPSparsePipeline ||= Class.new(Stretchy::Pipeline) do
      description "Sparse encoding pipeline"
      
      processor :sparse_encoding, 
            model_id: model_id,
            field_map: {
              body: :embedding
            }
    end
  end

  let(:onboarding_doc) do
    OnboardingDoc ||= Class.new(StretchyModel) do
    	attribute :body, :text
      attribute :status, :string
      attribute :filename, :keyword
      attribute :path, :keyword
      attribute :owner, :keyword
      attribute :client, :keyword
      attribute :embedding, :rank_features

      default_pipeline :nlp_sparse_pipeline
    end
  end

  let(:initial_data) do
    10.times.map do
      {
        "id" => Faker::Alphanumeric.alphanumeric(number: 7),
        "body" => Faker::Lorem.paragraph(sentence_count: 2),
        "status" => "active",
        "filename" => Faker::File.file_name,
        "path" => "/path/to/file",
        "owner" => Faker::Name.name,
        "client" => Faker::Company.name
      }
    end
  end

  let(:bulk_records) do
    initial_data.map do |record|
      { index: { _index: OnboardingDoc.index_name ,_id: record['id'], data: record } }
    end
  end

  let(:source_records) do
    initial_data.map do |record|
      { _source: record }
    end
  end

  before do
    # sparse_model.register
    # sparse_model.model_id
    sparse_pipeline.create!
    onboarding_doc.create_index!
    onboarding_doc.bulk(bulk_records)
    sleep(10)
  end

  after do
    onboarding_doc.delete_index! if onboarding_doc.index_exists?
    sparse_pipeline.delete!
    sparse_model.undeploy
    sparse_model.delete
  end

  it 'simulates a pipeline' do
    response = sparse_pipeline.simulate(source_records)
    statuses = response["docs"].map {|d| d["processor_results"].map {|pr| pr["status"]}}.flatten
    expect(statuses).to all(eq("success"))
  end

  it 'performs a neural search' do
    expect(onboarding_doc.default_pipeline).to eq('nlp_sparse_pipeline')
    expect(onboarding_doc.count).to eq(initial_data.size)
    expect(onboarding_doc.neural_search('test')).to not_be_empty
  end

end