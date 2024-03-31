namespace :stretchy do
  namespace :connector do

    desc "Check the status of all connectors"
    task status: :environment do
      klass = ENV['MODEL']

      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Connector.descendants : [klass.constantize]

      puts Rainbow("Connector").color :gray
      models.each do |model|
        
        begin
        response = model.find
        rescue Stretchy::MachineLearning::Errors::ConnectorMissingError => e
          puts "#{model}".ljust(JUSTIFICATION) + Rainbow("[MISSING]").white
          next
        end
        status = if response
          Rainbow("[CREATED]").green.bright
        else
          Rainbow("[MISSING]").white
        end
        puts "#{model}".ljust(JUSTIFICATION) + status
      end
      puts "\n\n"
    end

  end
end