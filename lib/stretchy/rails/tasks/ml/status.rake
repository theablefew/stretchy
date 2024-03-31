namespace :stretchy do
  namespace :ml do

    desc "Check the status of all ml models"
    task status: :environment do
      klass = ENV['MODEL']

      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Model.descendants : [klass.constantize]

      puts Rainbow("Machine Learning").color :gray
      models.each do |model|
        
        response = model.find['model_state']
        status = case response
          when 'DEPLOYED'
            Rainbow("[#{response}]").green.bright
          when 'DEPLOY_FAILED'
            Rainbow("[#{response}]").red.bright
          when 'CREATED'
            Rainbow("[#{response}]").yellow.bright
        else
          Rainbow("[MISSING]").white
        end
        puts "#{model}".ljust(JUSTIFICATION) + status
      end
      puts "\n\n"
    end

  end
end