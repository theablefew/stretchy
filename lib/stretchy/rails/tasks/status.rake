namespace :stretchy do
  namespace :status do
    desc "Check the status of all indexes"
    task all: :environment do
      Rake::Task['stretchy:index:status'].invoke
      Rake::Task['stretchy:pipeline:status'].invoke
      Rake::Task['stretchy:ml:status'].invoke
    end
  end

  desc "Check the status of all indexes, pipelines and ml models"
  task status: 'stretchy:status:all' do
  end
end