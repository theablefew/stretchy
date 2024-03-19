require 'spec_helper'

describe 'datetime' do
  
  let(:model) do
    stub_const("DateTimeModel", Class.new(StretchyModel) do
      attribute :date, :datetime
    end)
  end

  it 'casts value' do
    expect(model.new(date: '2020-01-01').date).to eq(DateTime.parse('2020-01-01'))
    expect(model.new(date: '2020-01-01T00:00:00').date).to eq(DateTime.parse('2020-01-01T00:00:00'))

  end

  it 'allows a custom format' do
    model.attribute :custom, :datetime, model_format: '%m/%d/%Y'
    expect(model.new(custom: '07/17/1918').custom).to eq(DateTime.parse('1918-07-17'))
    expect(model.new(custom: '17/07/1918').custom).to eq(DateTime.parse('1918-07-17'))
    expect(model.new(custom: '17/07/1918 ').custom).to eq(DateTime.parse('1918-07-17'))
    expect(model.new(custom: '17/07/1918 10:02').custom).to eq(DateTime.parse('1918-07-17 10:02'))
  end

  it 'returns a time' do
    expect(model.new(date: '2020-01-01').date).to be_a(Time)
  end

end