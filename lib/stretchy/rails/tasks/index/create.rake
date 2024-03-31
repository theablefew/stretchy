namespace :stretchy do
  namespace :index do
    desc "Create indices"
    task create: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? StretchyModel.descendants : [klass.constantize]
        models.each do |model|
          next if model.name == "Stretchy::MachineLearning::Registry"
          spinner = TTY::Spinner.new("Creating index #{model} (#{model.index_name}) ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
          spinner.auto_spin
          if model.index_exists?
            spinner.stop( Rainbow("[EXISTS]").orange)
            next
          end

          response = model.create_index!
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