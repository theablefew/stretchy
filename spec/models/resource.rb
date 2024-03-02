class Resource < Stretchy::Record

    index_name "resource_test"
    attribute :name, String
    attribute :email, String
    attribute :phone, String
    attribute :position, Stretchy::Attributes::Hash
    attribute :gender, String
    attribute :age, Integer
    attribute :income, Integer
    attribute :income_after_raise, Integer
 end