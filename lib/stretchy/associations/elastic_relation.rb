module Stretchy
    module Associations
        class ElasticRelation
            delegate :blank?, :empty?, :any?, :many?, :first, :last, to: :results
            delegate :to_xml, :to_yaml, :length, :collect, :map, :each, :all?, :include?, :to_ary, :join, to: :to_a

            attr_reader :klass
            alias :model :klass

            def initialize(klass, records = [], collection = true)
            @klass = klass
            @records = records
            @collection = collection
            end

            def build(*args)
            r = @klass.new(*args)
            @records << r
            r
            end

            def delete(opts = nil)
            dr = @records.delete_if { |r| r === opts }
            dr.first
            end

            def to_a
            @records
            end

            alias :results :to_a

            def collection?
            @collection
            end
        end
    end
end
