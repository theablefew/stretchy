module Stretchy
    class Record

        def self.inherited(base) 

            base.class_eval do

                extend Stretchy::Delegation::GatewayDelegation

                include ActiveModel::Model
                include ActiveModel::Attributes
                include ActiveModel::AttributeAssignment
                include ActiveModel::Naming
                include ActiveModel::Conversion
                include ActiveModel::Serialization
                include ActiveModel::Serializers::JSON

                include Stretchy::Model::Callbacks
                include Stretchy::Indexing::Bulk
                include Stretchy::Persistence
                include Stretchy::Associations 
                include Stretchy::Refreshable
                include Stretchy::Common
                include Stretchy::Scoping
                include Stretchy::Utils
                include Stretchy::SharedScopes

                extend Stretchy::Delegation::DelegateCache
                extend Stretchy::Querying

                # Set up common attributes
                attribute :id, :string #, default: lambda { SecureRandom.uuid }
                attribute :created_at, :datetime, default: lambda {  Time.now.utc }
                attribute :updated_at, :datetime, default: lambda { Time.now.utc }

                # Set the default sort key to be used in sort operations
                default_sort_key :created_at

                # Defaults max record size returned by #all
                # overriden by #size
                default_size 10000

                attr_accessor :highlights

                def initialize(attributes = {})
                    @highlights = attributes.delete(:_highlights) 
                    super(attributes)
                end

            end

            # def initialize(attributes = {})
            #     # self.assign_attributes(attributes) if attributes
            #     # super()
            # end

        end

    end
end
