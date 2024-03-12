require 'spec_helper' 

describe "Validations" do

  context 'in model' do
   before do
      Object.send(:remove_const, :TestModel) if Object.constants.include?(:TestModel)
      TestModel = Class.new(Stretchy::Record) do
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
    end

    let(:model) { TestModel }

    it 'validates presence' do
      record = model.new
      expect(record.valid?).to eq(false)
      expect(record.errors[:name]).to eq(["can't be blank"])
    end

    it 'validates numericality' do
      record = model.new(age: 19)
      expect(record.valid?).to eq(false)
      expect(record.errors[:age]).to eq(["must be greater than 21"])
    end

    it 'validates length' do
      record = model.new(tags: [])
      expect(record.valid?).to eq(false)
      expect(record.errors[:tags]).to eq(["is too short (minimum is 1 character)"])
    end

    it 'validates acceptance' do
      record = model.new(agreed: false)
      expect(record.valid?).to eq(false)
      expect(record.errors[:agreed]).to eq(["must be accepted"])
    end

    it 'validates presence' do
      record = model.new
      expect(record.valid?).to eq(false)
      expect(record.errors[:data]).to eq(["can't be blank"])
    end

  end
end
