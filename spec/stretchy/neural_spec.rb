require 'spec_helper'
require 'models/embedding_model'

describe 'opensearch neural search', opensearch_only: true do
  describe EmbeddingModel do
      context 'neural_sparse' do
          let(:results) do
              Elasticsearch::Persistence::Repository::Response::Results.new(described_class.gateway, 
              {
                  "took": 688,
                  "timed_out": false,
                  "_shards": {
                    "total": 1,
                    "successful": 1,
                    "skipped": 0,
                    "failed": 0
                  },
                  "hits": {
                    "total": {
                        "value": 1,
                        "relation": "eq"
                    },
                    "max_score": 30.0029,
                    "hits": [
                        {
                          "_index": "my-nlp-index",
                          "_id": "1",
                          "_score": 30.0029,
                          "_source": {
                              "passage_text": "Hello world",
                              "passage_embedding": {
                                  "!": 0.8708904,
                                  "door": 0.8587369,
                                  "hi": 2.3929274,
                                  "worlds": 2.7839446,
                                  "yes": 0.75845814,
                                  "##world": 2.5432441,
                                  "born": 0.2682308,
                                  "nothing": 0.8625516,
                                  "goodbye": 0.17146169,
                                  "greeting": 0.96817183,
                                  "birth": 1.2788506,
                                  "come": 0.1623208,
                                  "global": 0.4371151,
                                  "it": 0.42951578,
                                  "life": 1.5750692,
                                  "thanks": 0.26481047,
                                  "world": 4.7300377,
                                  "tiny": 0.5462298,
                                  "earth": 2.6555297,
                                  "universe": 2.0308156,
                                  "worldwide": 1.3903781,
                                  "hello": 6.696973,
                                  "so": 0.20279501,
                                  "?": 0.67785245
                               },
                              "id": "s1"
                          }
                        }
                    ],
                  }
                }.with_indifferent_access)
          end

          it 'responds' do
              expect(described_class).to respond_to(:neural_sparse)
          end

          it 'adds values' do
              values = described_class.neural_sparse(passage_embedding: 'hello world', model_id: '1234', max_token_score: 2).values[:neural_sparse]
              expect(values.first).to eq({passage_embedding: 'hello world', model_id: '1234', max_token_score: 2})
          end

          it 'has rank_features' do
              allow_any_instance_of(Elasticsearch::Persistence::Repository).to receive(:search).and_return(results)
              expect(described_class.neural_sparse(passage_embedding: 'hello world', model_id: '1234', max_token_score: 2).map(&:passage_embedding)).to all(be_a(Hash))
          end
      end

      context 'neural' do
        let(:results) do
            Elasticsearch::Persistence::Repository::Response::Results.new(described_class.gateway, 
            {
                "took": 25,
                "timed_out": false,
                "_shards": {
                    "total": 1,
                    "successful": 1,
                    "skipped": 0,
                    "failed": 0
                },
                "hits": {
                    "total": {
                        "value": 2,
                        "relation": "eq"
                    },
                    "max_score": 0.01585195,
                    "hits": [
                        {
                            "_index": "my-nlp-index",
                            "_id": "4",
                            "_score": 0.01585195,
                            "_source": {
                            "description": "A man who is riding a wild horse in the rodeo is very near to falling off .",
                            "id": "4427058951.jpg"
                            }
                        },
                        {
                            "_index": "my-nlp-index",
                            "_id": "2",
                            "_score": 0.015748845,
                            "_source": {
                            "description": "A wild animal races across an uncut field with a minimal amount of trees.",
                            "id": "1775029934.jpg"
                            }
                        }
                    ]
                }
            }.with_indifferent_access)
        end

        it 'responds' do
            expect(described_class).to respond_to(:neural)
        end

        it 'adds values' do
            values = described_class.neural(passage_embedding: { query_text: 'hello world', model_id: '1234'}).values[:neural]
            expect(values.first).to eq({passage_embedding: { query_text: 'hello world', model_id: '1234'}})
        end

        it 'returns results' do
            allow_any_instance_of(Elasticsearch::Persistence::Repository).to receive(:search).and_return(results)
            expect(described_class.neural(passage_embedding: 'hello world', model_id: '1234', k:2).total).to eq(2)
        end

        context 'multimodal' do
            it 'allows hash as field value' do
                elastic_hash = described_class.neural(passage_embedding: { 
                        query_text: 'hello world',
                        query_image: 'base64encodedimage',
                    }, 
                    model_id: '1234'
                ).to_elastic

                expect(elastic_hash.dig(:query, :neural)).to eq({passage_embedding: { query_text: 'hello world', query_image: 'base64encodedimage', model_id: '1234'}}.with_indifferent_access)
            end
        end
      end

      context 'hybrid' do
          it 'responds' do
              expect(described_class).to respond_to(:hybrid)
          end

          it 'adds values' do
              values = described_class.hybrid(neural: [{passage_embedding: 'hello world', model_id: '1234', k: 2}], query: [{term: {status: :active}}]).values[:hybrid]
              expect(values).to eq([{neural: [{passage_embedding: 'hello world', model_id: '1234', k: 2}], query: [{term: {status: :active}}]}])
          end
      end


  end
end