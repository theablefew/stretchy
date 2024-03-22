module Stretchy
  module Model
    # Adds callbacks to the model to refresh the index after save or destroy.
    #
    # ```ruby
    # included do
    #   after_save :refresh_index
    #   after_destroy :refresh_index
    # end
    # ```
    module Refreshable
      extend ActiveSupport::Concern

      
      included do
        after_save :refresh_index
        after_destroy :refresh_index
      end

      def refresh_index
        self.class.refresh_index!
      end

    end
  end
end
