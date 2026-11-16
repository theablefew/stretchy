namespace :stretchy do
  namespace :ml do
    namespace :agent do
      desc "Check the status of agents, or the agent ENV['AGENT']"
      task status: :environment do
        agents = Stretchy::RakeHelpers.resources(Stretchy::MachineLearning::Agent, env: 'AGENT')
        puts Rainbow("Agent").color :gray
        agents.each do |agent|
          status = agent.exists? ? Rainbow("[REGISTERED]").green.bright : Rainbow("[MISSING]").white
          puts "#{agent}".ljust(JUSTIFICATION) + status
        end
        puts "\n\n"
      end
    end
  end
end
