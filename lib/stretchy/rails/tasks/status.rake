namespace :stretchy do
  namespace :status do
    desc "Check the status of all indexes"
    task all: :environment do
      klass = ENV['MODEL']
      unless klass.nil?
        klass = klass.constantize
      end

      Rake::Task['stretchy:index:status'].invoke
      Rake::Task['stretchy:pipeline:status'].invoke
      Rake::Task['stretchy:ml:status'].invoke


    end
  end

  desc "Check the status of all indexes, pipelines and ml models"
  task status: 'stretchy:status:all' do
  end
end