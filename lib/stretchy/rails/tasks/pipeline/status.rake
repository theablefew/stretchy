namespace :stretchy do
  namespace :pipeline do
    desc "Check the status of ingest and search pipelines, or the pipeline ENV['PIPELINE']"
    task status: :environment do
      pipelines = Stretchy::RakeHelpers.resources(Stretchy::Pipelines::Base, env: 'PIPELINE').select(&:available?)
      puts Rainbow("Pipelines").color :gray
      pipelines.each do |pipeline|
        status = pipeline.exists? ? Rainbow("[CREATED]").green.bright : Rainbow("[MISSING]").white
        puts "#{pipeline.pipeline_name}".ljust(JUSTIFICATION) + status
      end
      puts "\n\n"
    end
  end
end
