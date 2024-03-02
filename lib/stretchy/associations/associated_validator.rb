module Stretchy
    module Associations
        class AssociatedValidator < ActiveModel::EachValidator #:nodoc:
            def validate_each(record, attribute, value)
            if Array(value).reject { |r| valid_object?(r) }.any?
                record.errors.add(attribute, :invalid, options.merge(value: value))
            end
            end

            private

            def valid_object?(record)
            record.valid?
            end
        end
    end
end
