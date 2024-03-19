require 'spec_helper'

describe 'API' do

  let(:backend) { Stretchy.configuration.search_backend_const }

  before do
    "#{backend}::API".constantize.send(:include, "#{backend}::API::MachineLearning::Models".constantize)
  end

  it 'should have a client' do
    puts Stretchy::MachineLearning::Model.client
    expect(Stretchy::MachineLearning::Model.client).to be_a("#{backend}::API::MachineLearning::Models::MachineLearningClient".constantize)
  end

  it 'should lookup a model' do
    expect(Stretchy::MachineLearning::Model.client.get_model ).to be_a(Hash)
  end
end