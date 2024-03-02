module Stretchy
    class Repository

        include Elasticsearch::Persistence::Repository
        include Elasticsearch::Persistence::Repository::DSL

        include Stretchy::Model::Serialization

    end
end