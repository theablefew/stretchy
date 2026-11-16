require "spec_helper"
require "models/post"

describe Stretchy::Repository::Results do
  subject(:results) { described_class.new(Post.gateway, response) }

  let(:response) do
    {
      "hits" => {
        "total" => { "value" => 2, "relation" => "eq" },
        "max_score" => 1.5,
        "hits" => [
          { "_id" => "1", "_score" => 1.5, "_source" => { "title" => "hello" } },
          { "_id" => "2", "_score" => 1.0, "_source" => { "title" => "goodbye" }, "highlight" => { "title" => ["<em>goodbye</em>"] } }
        ]
      },
      "aggregations" => { "titles" => { "buckets" => [] } }
    }
  end

  it 'deserializes hits into records' do
    expect(results.map(&:title)).to eq(['hello', 'goodbye'])
    expect(results.first.id).to eq('1')
  end

  it 'reads the total from the hits total object' do
    expect(results.total).to eq(2)
  end

  it 'reads a numeric hits total' do
    response["hits"]["total"] = 2
    expect(results.total).to eq(2)
  end

  it 'exposes the max score' do
    expect(results.max_score).to eq(1.5)
  end

  it 'pairs records with their hits' do
    expect(results.map_with_hit { |post, hit| [post.title, hit['_score']] }).to eq([['hello', 1.5], ['goodbye', 1.0]])
  end

  it 'gives method access to the response' do
    expect(results.response.aggregations.titles.buckets).to eq([])
  end

  it 'accepts responses with symbol keys' do
    results = described_class.new(Post.gateway, { hits: { total: { value: 0 }, hits: [] } })
    expect(results.total).to eq(0)
    expect(results.to_a).to eq([])
  end
end
