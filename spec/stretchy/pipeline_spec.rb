require 'spec_helper'

describe Stretchy::Pipeline do

    let!(:pipeline_class)  do
      TestPipeline ||= Class.new(Stretchy::Pipeline) do
        description 'A test pipeline'
        processor :sparse_encoding, model_id: 'q32Pw02BJ3squ3VZa',
				field_map: {
					body: :embedding
				}
      end
    end


    it 'should have an inferred pipeline name' do
      expect(pipeline_class.pipeline_name).to eq('test_pipeline')
    end

    it 'should have a description' do
      expect(pipeline_class.description).to eq('A test pipeline')
    end

    it 'should have a processor' do
      expect(pipeline_class.processors.first).to be_a(Stretchy::Pipelines::Processor)
      expect(pipeline_class.processors.first.type).to eq(:sparse_encoding)
      expect(pipeline_class.processors.first.opts).to eq({model_id: 'q32Pw02BJ3squ3VZa', field_map: {body: :embedding}})
    end

    it 'should list all pipelines' do
      expect(pipeline_class.all).to be_a(Hash)
    end


    let(:pipeline) { pipeline_class.new }
    context 'instance' do
      it 'should have a pipeline name' do
        expect(pipeline.pipeline_name).to eq('test_pipeline')
      end

      it 'should have a description' do
        expect(pipeline.description).to eq('A test pipeline')
      end

      it 'should have a processor' do
        expect(pipeline.processors.first).to be_a(Stretchy::Pipelines::Processor)
        expect(pipeline.processors.first.type).to eq(:sparse_encoding)
        expect(pipeline.processors.first.opts).to eq({model_id: 'q32Pw02BJ3squ3VZa', field_map: {body: :embedding}})
      end
    end

    context 'api client' do
      it 'appears as a hash' do
        expect(pipeline.to_hash).to eq({
          description: 'A test pipeline', 
          processors: [
            {
              sparse_encoding: {
                model_id: 'q32Pw02BJ3squ3VZa',
                field_map: {
                  body: :embedding
                }
              }
            }
          ]
        }.as_json)
      end

      it 'should create a new pipeline' do
        allow(pipeline.client).to receive(:put_pipeline).and_return({"acknowledged"=>true})
        expect(pipeline.create).to eq({"acknowledged"=>true})
      end

      it 'should intercept NotFound in exists?' do
        allow(pipeline_class).to receive(:find).and_raise(pipeline.send(:not_found))
        expect(pipeline.exists?).to be_falsey
      end

      let(:simulation_response) do
        {
          "docs" => [
            {
              "processor_results" => [
                {
                  "processor_type" => "uppercase",
                  "status"         => "success",
                  "doc"            => {
                    "_index"  => "_index",
                    "_id"     => "_id",
                    "_source" => {
                      "name" => "TEST"
                    },
                    "_ingest" => {
                      "pipeline"  => "uppercase-pipeline",
                      "timestamp" => "2024-03-16T20:36:04.388880257Z"
                    }
                  }
                }
              ]
            }
          ]
        }
      end

      it 'should simulate a pipeline' do
        uppercase = Class.new(Stretchy::Pipeline) do
          pipeline_name 'uppercase-pipeline'
          description 'Uppercase'
          processor :uppercase, field: :name
        end.new

        allow(uppercase.client).to receive(:simulate).and_return(simulation_response)
        allow(uppercase.client).to receive(:put_pipeline).and_return({"acknowledged"=>true})
        expect(uppercase.pipeline_name).to eq('uppercase-pipeline')
        expect(uppercase.description).to eq('Uppercase')
        expect(uppercase.create).to eq({"acknowledged"=>true})
        expect(uppercase.simulate([{_source: {name: 'test'}}])).to eq(simulation_response)
      end

      it 'should retrieve a pipeline' do
        allow(pipeline.client).to receive(:get_pipeline).and_return({pipeline.pipeline_name => pipeline.to_hash})
        expect(pipeline.find).to eq({pipeline.pipeline_name => pipeline.to_hash})
      end

      it 'should delete a pipeline' do
        allow(pipeline.client).to receive(:delete_pipeline).and_return({"acknowledged"=>true})
        expect(pipeline.delete).to eq({"acknowledged"=>true})
      end
    end
end