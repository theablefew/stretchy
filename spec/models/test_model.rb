class TestModel < StretchyModel
  attribute :name, :text
  attribute :age, :integer
  attribute :tags, :array
  attribute :data, :hash
  attribute :published_at, :datetime
  attribute :agreed, :boolean

end