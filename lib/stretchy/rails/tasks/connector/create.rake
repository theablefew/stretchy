namespace :stretchy do
  namespace :connector do
    desc "Create connector"
    task create: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Connector.descendants : [klass.constantize]
        models.each do |model|
          spinner = TTY::Spinner.new("Creating Connector #{model} ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
          spinner.auto_spin

          # if model.exists?
          #   spinner.stop(Rainbow("[EXISTS]").yellow)
          #   next
          # end

          begin
            response = model.create!
          rescue Stretchy::MachineLearning::Errors::ConnectorMissingError => e
            spinner.stop(Rainbow("[FAILED]").red)
            next
          end
          status = if response
            Rainbow("[SUCCESS]").green
          else
            Rainbow("[FAILED]").red
          end
          spinner.stop(status)
        end
      end
  end
end