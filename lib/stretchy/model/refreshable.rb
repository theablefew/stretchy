module Stretchy
  module Model
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
