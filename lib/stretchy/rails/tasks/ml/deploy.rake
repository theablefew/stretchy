namespace :stretchy do
  namespace :ml do

    desc "Register the model ENV['MODEL']"
    task register: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Model.descendants : [klass.constantize]

      models.each do |model|
        spinner = TTY::Spinner.new(("Registering #{model} ".ljust(JUSTIFICATION) + ":spinner"), format: :dots)
        spinner.auto_spin
        if model.registered?
          spinner.stop(Rainbow("[SUCCESS]").green)
          next
        end

        model.register do  |m|
          m.wait_until_complete do
            m.registered?
          end
        end

        status = model.registered? ? Rainbow("[SUCCESS]").green : Rainbow("[FAILED]").red
        spinner.stop(status)
      end
    end

    desc "Undeploy the model ENV['MODEL']"
    task undeploy: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Model.descendants : [klass.constantize]
      models.each do |model|
        spinner = TTY::Spinner.new("Undeploying #{model} ". ljust(JUSTIFICATION) + ":spinner", format: :dots)
        spinner.auto_spin

        unless model.deployed?
          spinner.stop(Rainbow("[NOT DEPLOYED]").white)
          next
        end

        model.undeploy do |m|
          m.wait_until_complete do
            !m.deployed?
          end
        end
        status = !model.deployed? ?  Rainbow("[SUCCESS]").green : Rainbow("[DEPLOYED]").yellow
        spinner.stop(status)
      end
    end

    desc "Deploy the model ENV['MODEL']"
    task deploy: :environment do
      klass = ENV['MODEL']
      Rails.application.eager_load!
      models = klass.nil? ? Stretchy::MachineLearning::Model.descendants : [klass.constantize]
      models.each do |model|
        spinner = TTY::Spinner.new("Deploying #{model} ".ljust(JUSTIFICATION) + ":spinner", format: :dots)
        spinner.auto_spin

        if model.deployed?
          spinner.stop(Rainbow("[SUCCESS]").green)
          next
        end

        model.deploy do |m|
          m.wait_until_complete do
            m.deployed?
          end
        end
        status = model.deployed? ? Rainbow("[SUCCESS]").green : Rainbow("[FAILED]").red 
        spinner.stop(status)
      end
    end

  end
end