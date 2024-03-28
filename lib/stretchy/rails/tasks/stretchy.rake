require 'stretchy-model'
require 'tty-spinner'

JUSTIFICATION = 90 unless defined?(JUSTIFICATION)

path = File.expand_path(__dir__)
Dir.glob("#{path}/**/*.rake").each { |f| import f }
namespace :stretchy do
  desc "Create all indexes, pipelines and deploy all models"
  task up: :environment do
    Rake::Task['stretchy:ml:register'].invoke
    Rake::Task['stretchy:ml:deploy'].invoke
    Rake::Task['stretchy:pipeline:create'].invoke
    Rake::Task['stretchy:index:create'].invoke
  end

  desc "Delete all indexes, pipelines and undeploy all models"
  task down: :environment do
    Rake::Task['stretchy:ml:undeploy'].invoke
    Rake::Task['stretchy:ml:delete'].invoke
    Rake::Task['stretchy:pipeline:delete'].invoke
    Rake::Task['stretchy:index:delete'].invoke
  end
end