require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/hash/slice'

module Stretchy
  module Relations

      module SpawnMethods
        def spawn
          clone
        end

        def merge(other)
          if other.is_a?(Array)
            to_a & other
          elsif other
            spawn.merge!(other)
          else
            self
          end
        end

        def merge!(other) # :nodoc:
          if !other.is_a?(Relation) && other.respond_to?(:to_proc)
            instance_exec(&other)
          else
            klass = other.is_a?(Hash) ? Relation::HashMerger : Relation::Merger
            klass.new(self, other).merge
          end
        end

        # Removes from the query the condition(s) specified in +skips+.
        #
        #   Post.order('id asc').except(:order)                  # discards the order condition
        #   Post.where('id > 10').order('id asc').except(:where) # discards the where condition but keeps the order
        def except(*skips)
          relation_with values.except(*skips)
        end

        # Removes any condition from the query other than the one(s) specified in +onlies+.
        #
        #   Post.order('id asc').only(:where)         # discards the order condition
        #   Post.order('id asc').only(:where, :order) # uses the specified order
        def only(*onlies)
          if onlies.any? { |o| o == :where }
            onlies << :bind
          end
          relation_with values.slice(*onlies)
        end

        private

        def relation_with(values) # :nodoc:
          result = Relation.create(klass, values)
          result.extend(*extending_values) if extending_values.any?
          result
        end
      end

    end
end
