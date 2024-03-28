namespace :stretchy do
  namespace :index do
    desc "Delete indices"
    task delete: :environment do
      klass = ENV['MODEL']
      models = klass.nil? ? StretchyModel.descendants : [klass.constantize]
        models.each do |model|
          next if model.name == "Stretchy::MachineLearning::Registry"
          spinner = TTY::Spinner.new("Deleting index #{model} (#{model.index_name}) ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
          spinner.auto_spin
          unless model.index_exists?
            spinner.stop( Rainbow("[MISSING]").white)
            next
          end

          response = model.delete_index!
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