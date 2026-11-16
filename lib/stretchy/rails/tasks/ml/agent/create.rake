namespace :stretchy do
  namespace :ml do
    namespace :agent do
      desc "Register agents, or the agent ENV['AGENT']"
      task create: :environment do
        agents = Stretchy::RakeHelpers.resources(Stretchy::MachineLearning::Agent, env: 'AGENT')
        Stretchy::RakeHelpers.each_with_spinner(agents, "Creating Agent") do |agent|
          next Rainbow("[EXISTS]").yellow if agent.exists?
          agent.register! ? Rainbow("[SUCCESS]").green : Rainbow("[FAILED]").red
        rescue => e
          Stretchy.logger.error "Error creating agent #{agent}: #{e.message}"
          Rainbow("[FAILED]").red
        end
      end
    end
  end
end
