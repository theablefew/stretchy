class ModelWithValidations < StretchyModel
  attribute :name, :text
  attribute :age, :integer
  attribute :tags, :array
  attribute :data, :hash
  attribute :published_at, :datetime
  attribute :agreed, :boolean

  validates :name, presence: true
  validates :age,  numericality: { only_integer: true, greater_than: 21}
  validates :tags, length: { minimum: 1 }
  validates :data, presence: true
  validates :agreed, acceptance: true
end