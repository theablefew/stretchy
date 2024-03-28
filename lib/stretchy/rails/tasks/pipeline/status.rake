namespace :stretchy do
  namespace :pipeline do

    desc "Check the status of all pipelines"
    task status: :environment do
      klass = ENV['MODEL']

      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::Pipeline.descendants : [klass.constantize]

      puts Rainbow("Pipelines").color :gray
      models.each do |model|
        response = model.exists?
        status = if response
          Rainbow("[CREATED]").green.bright
        else
          Rainbow("[MISSING]").white
        end
        puts "#{model.pipeline_name}".ljust(JUSTIFICATION) + status
      end
      puts "\n\n"
    end

  end
end