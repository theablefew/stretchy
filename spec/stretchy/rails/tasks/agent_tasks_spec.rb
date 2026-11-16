require 'spec_helper'
require 'rake'
require 'rainbow'
require 'tty-spinner'

describe 'stretchy:ml:agent tasks', opensearch_only: true do
  let(:agent) { double('SupportAgent', to_s: 'SupportAgent') }

  before(:all) do
    JUSTIFICATION = 90 unless defined?(JUSTIFICATION)
    Rake.application = Rake::Application.new
    Rake::Task.define_task(:environment)
    Dir[File.expand_path('../../../../lib/stretchy/rails/tasks/ml/agent/*.rake', __dir__)].each { |file| load file }
  end

  before do
    allow(Stretchy::RakeHelpers).to receive(:resources).with(Stretchy::MachineLearning::Agent, env: 'AGENT').and_return([agent])
    allow_any_instance_of(TTY::Spinner).to receive(:auto_spin)
    allow_any_instance_of(TTY::Spinner).to receive(:stop)
    allow($stdout).to receive(:puts)
  end

  after { Rake::Task.tasks.each(&:reenable) }

  it 'registers agents that do not exist' do
    allow(agent).to receive(:exists?).and_return(false)
    expect(agent).to receive(:register!).and_return('agent-1')
    Rake::Task['stretchy:ml:agent:create'].invoke
  end

  it 'skips agents that already exist' do
    allow(agent).to receive(:exists?).and_return(true)
    expect(agent).not_to receive(:register!)
    Rake::Task['stretchy:ml:agent:create'].invoke
  end

  it 'deletes agents that exist' do
    allow(agent).to receive(:exists?).and_return(true)
    expect(agent).to receive(:delete!)
    Rake::Task['stretchy:ml:agent:delete'].invoke
  end

  it 'reports status' do
    expect(agent).to receive(:exists?).and_return(true)
    Rake::Task['stretchy:ml:agent:status'].invoke
  end
end
