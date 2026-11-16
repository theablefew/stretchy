namespace :stretchy do
  namespace :pipeline do
    desc "Delete ingest and search pipelines, or the pipeline ENV['PIPELINE']"
    task delete: :environment do
      pipelines = Stretchy::RakeHelpers.resources(Stretchy::Pipelines::Base, env: 'PIPELINE').select(&:available?)
      Stretchy::RakeHelpers.each_with_spinner(pipelines, "Deleting Pipeline") do |pipeline|
        next Rainbow("[MISSING]").white unless pipeline.exists?
        pipeline.delete!['acknowledged'] ? Rainbow("[SUCCESS]").green : Rainbow("[FAILED]").red
      end
    end
  end
end
