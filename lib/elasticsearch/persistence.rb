require 'elasticsearch'
require 'elasticsearch/model/indexing'
require 'hashie'
require 'jbuilder'

require 'rails/instrumentation/railtie' if defined?(Rails)

# require 'elasticsearch/rails_compatibility'
require_relative 'per_thread_registry'

require 'elasticsearch/persistence/version'

require 'elasticsearch/persistence/client'
require 'elasticsearch/persistence/scoping'
require 'elasticsearch/persistence/scoping/default'
require 'elasticsearch/persistence/scoping/named'
require 'elasticsearch/persistence/inheritence'
require 'elasticsearch/persistence/querying'
require 'elasticsearch/persistence/query_cache'

require 'elasticsearch/persistence/repository/response/results'
require 'elasticsearch/persistence/repository/naming'
require 'elasticsearch/persistence/repository/serialize'
require 'elasticsearch/persistence/repository/store'
require 'elasticsearch/persistence/repository/find'
require 'elasticsearch/persistence/repository/search'
require 'elasticsearch/persistence/repository/class'
require 'elasticsearch/persistence/repository'

require 'elasticsearch/persistence/relations/finder_methods'
require 'elasticsearch/persistence/relations/query_methods'
require 'elasticsearch/persistence/relations/search_option_methods'
require 'elasticsearch/persistence/relations/spawn_methods'
require 'elasticsearch/persistence/relations/delegation'
require 'elasticsearch/persistence/relations/merger'

require 'elasticsearch/persistence/relation'
require 'elasticsearch/persistence/null_relation'


module Elasticsearch
  # Persistence for Ruby domain objects and models in Elasticsearch
  # ===============================================================
  #
  # `Elasticsearch::Persistence` contains modules for storing and retrieving Ruby domain objects and models
  # in Elasticsearch.
  #
  # == Repository
  #
  # The repository patterns allows to store and retrieve Ruby objects in Elasticsearch.
  #
  #     require 'elasticsearch/persistence'
  #
  #     class Note
  #       def to_hash; {foo: 'bar'}; end
  #     end
  #
  #     repository = Elasticsearch::Persistence::Repository.new
  #
  #     repository.save Note.new
  #     # => {"_index"=>"repository", "_type"=>"note", "_id"=>"mY108X9mSHajxIy2rzH2CA", ...}
  #
  # Customize your repository by including the main module in a Ruby class
  #     class MyRepository
  #       include Elasticsearch::Persistence::Repository
  #
  #       index 'my_notes'
  #       klass Note
  #
  #       client Elasticsearch::Client.new log: true
  #     end
  #
  #     repository = MyRepository.new
  #
  #     repository.save Note.new
  #     # 2014-04-04 22:15:25 +0200: POST http://localhost:9200/my_notes/note [status:201, request:0.009s, query:n/a]
  #     # 2014-04-04 22:15:25 +0200: > {"foo":"bar"}
  #     # 2014-04-04 22:15:25 +0200: < {"_index":"my_notes","_type":"note","_id":"-d28yXLFSlusnTxb13WIZQ", ...}
  #
  # == Model
  #
  # The active record pattern allows to use the interface familiar from ActiveRecord models:
  #
  #     require 'elasticsearch/persistence'
  #
  #     class Article
  #       attribute :title, String, mapping: { analyzer: 'snowball' }
  #     end
  #
  #     article = Article.new id: 1, title: 'Test'
  #     article.save
  #
  #     Article.find(1)
  #
  #     article.update_attributes title: 'Update'
  #
  #     article.destroy
  #
  module Persistence
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Client
      autoload :Model
      autoload :Repository
      autoload :Scoping
      autoload :Relation
      autoload :NullRelation
      autoload :Querying
      autoload :Inheritence
      autoload :QueryCache

      autoload_under 'relation' do
        autoload :QueryMethods
        autoload :QueryBuilder
        autoload :SearchOptionMethods
        autoload :FinderMethods
        autoload :SpawnMethods
        autoload :Delegation
      end
    end

    module Model
      extend ActiveSupport::Autoload

      autoload :GatewayDelegation
      #autoload :Callbacks
    end

    module Repository
      extend ActiveSupport::Autoload
      autoload :Class
      autoload :Find
      autoload :Search
      autoload :Serialize
      autoload :Store
      autoload :Naming
    end

    module Scoping
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :Named
        autoload :Default
      end
    end

    def self.eager_load!
      super
      Elasticsearch::Persistence::Scoping.eager_load!
    end

    extend Client::ClassMethods
    extend QueryCache::CacheMethods

  end
end
