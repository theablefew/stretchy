module Stretchy
  module Refreshable
    extend ActiveSupport::Concern

    included do
      after_save :refresh_index
      after_destroy :refresh_index
      after_create :refresh_index
      after_update :refresh_index
    end

    def refresh_index
      self.class.refresh_index
    end

    module ClassMethods
      def refresh_index
        gateway.refresh_index!
      end
    end
  end
end
