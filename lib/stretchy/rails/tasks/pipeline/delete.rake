namespace :stretchy do
  namespace :pipeline do
    desc "Delete pipeline"
    task delete: :environment do
      klass = ENV['MODEL']
      models = klass.nil? ? Stretchy::Pipeline.descendants : [klass.constantize]
        models.each do |model|
          spinner = TTY::Spinner.new("Deleting Pipeline #{model} ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
          spinner.auto_spin

          unless model.exists?
            spinner.stop(Rainbow("[MISSING]").white)
            next
          end

          response = model.delete!
          status = if response['acknowledged']
            Rainbow("[SUCCESS]").green
          else
            Rainbow("[FAILED]").red
          end
          spinner.stop(status)
        end
      end
  end
end