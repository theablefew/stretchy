class TestModel < StretchyModel
  attribute :name, :text
  attribute :age, :integer
  attribute :tags, :array
  attribute :data, :hash
  attribute :published_at, :datetime
  attribute :agreed, :boolean
  attribute :color, :keyword
  attribute :text_with_keyword, :text, fields: {slug: {type: :keyword}}

end