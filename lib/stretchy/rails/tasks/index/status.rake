namespace :stretchy do
  namespace :index do
    desc "Check the status of all indexes"
    task status: :environment do
      klass = ENV['MODEL']

      Rails.application.eager_load!
      models = klass.nil? ? StretchyModel.descendants : [klass.constantize]

      puts Rainbow("Indexes").color :gray
      models.each do |model|
        response = model.index_exists?
        status = if response
          Rainbow("[CREATED]").green.bright
        else
          Rainbow("[MISSING]").white
        end
        puts "#{model.index_name}".ljust(JUSTIFICATION) + status
      end
      puts "\n\n"
    end
  end
end