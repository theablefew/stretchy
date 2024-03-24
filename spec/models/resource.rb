class Resource < Stretchy::Record
    index_name "resource_test"

    attribute :name,                :string
    attribute :email,               :keyword
    attribute :phone,               :string
    attribute :position,            :hash
    attribute :gender,              :string
    attribute :age,                 :integer
    attribute :income,              :integer
    attribute :income_after_raise,  :integer
    attribute :description,         :text


 end