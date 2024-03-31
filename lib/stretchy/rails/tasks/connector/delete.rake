namespace :stretchy do
  namespace :connector do
    desc "Delete Connector"
    task delete: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Connector.descendants : [klass.constantize]
        models.each do |model|
          spinner = TTY::Spinner.new("Deleting Connector #{model} ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
          spinner.auto_spin

          begin
            response = model.delete!
          rescue Stretchy::MachineLearning::Errors::ConnectorMissingError => e
            spinner.stop(Rainbow("[MISSING]").white)
            next
          end
          status = if response['result'] == 'deleted'
            Rainbow("[SUCCESS]").green
          else
            Rainbow("[#{response['result'].upcase}]").white
          end
          spinner.stop(status)
        end
      end
  end
end