require 'spec_helper' 
require 'models/with_validations'

describe "Validations" do

  context 'in model' do

    let(:model) { ModelWithValidations }

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
