class Post < Stretchy::Record


    attribute :title,                   String
    attribute :body,                    String
    attribute :flagged,                 Boolean,  default: false  
    attribute :actor,                   Stretchy::Attributes::Hash
    attribute :tags,                    Array, default: []

    # Scopes

    scope :flagged, -> { where(flagged: true) }

end
