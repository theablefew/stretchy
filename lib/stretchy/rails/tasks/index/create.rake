namespace :stretchy do
  namespace :index do
    desc "Create the index"
    task create: :environment do
      klass = ENV['MODEL']
      unless klass.nil?
        klass = klass.constantize
        # klass.create_index!
      else
        StretchyModel.descendants.each do |klass|
          Rainbow("Creating index for #{klass}").bright

          # response = klass.create_index!
          if response['acknowledged']
            Rainbow("[SUCCESS]").green
          else
            Rainbow("[FAILED]").red
          end
        end
      end
    end
  end
end