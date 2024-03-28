namespace :stretchy do
  namespace :index do
    desc "Check the status of all indexes"
    task status: :environment do
      klass = ENV['MODEL']
      unless klass.nil?
        klass = klass.constantize
      end
      Rails.application.eager_load!

      puts Rainbow("Indexes").color :gray
      StretchyModel.descendants.each do |klass|
        response = klass.index_exists?
        status = if response
          Rainbow("[CREATED]").green.bright
        else
          Rainbow("[MISSING]").gray.bright
        end
        puts "#{klass.index_name}".ljust(60) + status
      end
      puts "\n\n"
    end
  end
end