namespace :stretchy do
  namespace :pipeline do

    desc "Check the status of all pipelines"
    task status: :environment do
      klass = ENV['MODEL']
      unless klass.nil?
        klass = klass.constantize
      end

      Rails.application.eager_load!

      puts Rainbow("Pipelines").color :gray
      Stretchy::Pipeline.descendants.each do |klass|
        response = klass.exists?
        status = if response
          Rainbow("[CREATED]").green.bright
        else
          Rainbow("[MISSING]").gray.bright
        end
        puts "#{klass.pipeline_name}".ljust(60) + status
      end
      puts "\n\n"
    end

  end
end