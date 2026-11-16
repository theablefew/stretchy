namespace :stretchy do
  namespace :pipeline do
    desc "Create ingest and search pipelines, or the pipeline ENV['PIPELINE']"
    task create: :environment do
      pipelines = Stretchy::RakeHelpers.resources(Stretchy::Pipelines::Base, env: 'PIPELINE').select(&:available?)
      Stretchy::RakeHelpers.each_with_spinner(pipelines, "Creating Pipeline") do |pipeline|
        pipeline.create!['acknowledged'] ? Rainbow("[SUCCESS]").green : Rainbow("[FAILED]").red
      rescue => e
        Stretchy.logger.error "Error creating pipeline #{pipeline}: #{e.message}"
        Rainbow("[FAILED]").red
      end
    end
  end
end
