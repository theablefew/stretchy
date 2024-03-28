namespace :stretchy do
  namespace :ml do

    desc "Delete the model ENV['MODEL']"
    task delete: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Model.descendants : [klass.constantize]

      models.each do |model|
        spinner = TTY::Spinner.new(("Deleting #{model} ".ljust(JUSTIFICATION) + ":spinner"), format: :dots)
        spinner.auto_spin
        unless model.registered?
          spinner.stop(Rainbow("[MISSING]").white)
          next
        end

        model.delete

        status = !model.registered? ? Rainbow("[DELETED]").green : Rainbow("[NOT DELETED]").yellow
        spinner.stop(status)
      end
    end
  end
end