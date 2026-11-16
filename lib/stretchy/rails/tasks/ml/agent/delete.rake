namespace :stretchy do
  namespace :ml do
    namespace :agent do
      desc "Delete agents, or the agent ENV['AGENT']"
      task delete: :environment do
        agents = Stretchy::RakeHelpers.resources(Stretchy::MachineLearning::Agent, env: 'AGENT')
        Stretchy::RakeHelpers.each_with_spinner(agents, "Deleting Agent") do |agent|
          next Rainbow("[MISSING]").white unless agent.exists?
          agent.delete!
          Rainbow("[DELETED]").green
        rescue => e
          Stretchy.logger.error "Error deleting agent #{agent}: #{e.message}"
          Rainbow("[FAILED]").red
        end
      end
    end
  end
end
