require 'spec_helper'

describe Stretchy::RakeHelpers do
  let(:base) { Class.new }
  let!(:first) { stub_const('FirstResource', Class.new(base)) }
  let!(:second) { stub_const('SecondResource', Class.new(base)) }

  around do |example|
    original = ENV['RESOURCE']
    example.run
    ENV['RESOURCE'] = original
  end

  it 'returns every descendant when the env variable is unset' do
    ENV['RESOURCE'] = nil
    expect(described_class.resources(base, env: 'RESOURCE')).to contain_exactly(first, second)
  end

  it 'returns the class named by the env variable' do
    ENV['RESOURCE'] = 'SecondResource'
    expect(described_class.resources(base, env: 'RESOURCE')).to eq([second])
  end
end
