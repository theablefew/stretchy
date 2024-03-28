namespace :stretchy do
  namespace :ml do

    desc "Check the status of all pipelines"
    task status: :environment do
      klass = ENV['MODEL']
      unless klass.nil?
        klass = klass.constantize
      end

      Rails.application.eager_load!

      puts Rainbow("MachineLearning").color :gray
      Stretchy::MachineLearning::Model.descendants.each do |klass|
        
        response = "FAILED"#klass.client.get_model(id: 'm9G-gI4BMe6MfgkYifM9').dig('model_state')
        status = if response
          case response
          when 'DEPLOYED'
            Rainbow("[#{response}]").green.bright
          when 'FAILED'
            Rainbow("[#{response}]").red.bright
          when 'CREATED'
            Rainbow("[#{response}]").yellow.bright
          end
        else
          Rainbow("[MISSING]").white.dim
        end
        puts "#{klass}".ljust(60) + status
      end
      puts "\n\n"
    end

  end
end