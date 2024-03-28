namespace :stretchy do
  namespace :pipeline do
    desc "Create pipeline"
    task create: :environment do
      klass = ENV['MODEL']
      models = klass.nil? ? Stretchy::Pipeline.descendants : [klass.constantize]
        models.each do |model|
          spinner = TTY::Spinner.new("Creating Pipeline #{model} ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
          spinner.auto_spin

          begin
            response = model.create!
          rescue => e
            spinner.stop(Rainbow("[FAILED]").red)
            puts e.message
            next
          end
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