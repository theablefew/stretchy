class Post < Stretchy::Record


    attribute :title,                   :string
    attribute :body,                    :string
    attribute :flagged,                 :boolean,  default: false  
    attribute :actor,                   :hash 
    attribute :tags,                    :array, default: []

    # Scopes
    scope :flagged, -> { where(flagged: true) }

    mapping do
        indexes :title, type: 'string', analyzer: 'english'
        indexes :body, type: 'string', analyzer: 'english'
        indexes :flagged, type: 'boolean'
        indexes :actor, type: 'object' do
            indexes :name, type: 'string'
            indexes :age, type: 'integer'
            indexes :username, type: 'string'
        end
        indexes :tags, type: 'string'
    end
end
