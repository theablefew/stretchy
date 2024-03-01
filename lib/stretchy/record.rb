module Stretchy
    class Record

        def self.inherited(base) 

            base.class_eval do

                include Elasticsearch::Persistence::Model
                include Stretchy::Associations 
                include Stretchy::Refreshable

                default_size 10000

                # Set up common attributes
                attribute :created_at, DateTime, default: lambda { |o, a| Time.now.utc }
                attribute :updated_at, DateTime, default: lambda { |o, a| Time.now.utc }

                default_sort_key :created_at
            end

        end

    end
end
