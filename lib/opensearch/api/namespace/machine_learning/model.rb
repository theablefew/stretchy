Dir[File.expand_path('../../actions/**/*.rb', __dir__)].sort.each   { |f| require f }

module OpenSearch
  module API
    module MachineLearning
      module Models
          module Actions; end
    
          # Client for the "machine_learning/models" namespace (includes the {MachineLearning::Models::Actions} methods)
          #
          class MachineLearningClient
            include MachineLearning::Models::Actions
            include OpenSearch::API::Common::Client::Base
            include OpenSearch::API::Common::Client
          end
    
          # Proxy method for {MachineLearningModel}, available in the receiving object
          #
          def machine_learning
            @machine_learning ||= MachineLearningClient.new(self)
          end
    
          alias ml machine_learning
        end
    end
  end
end