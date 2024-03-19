require 'spec_helper'
require 'faker'

describe 'Ingest Pipeline', type: :integration do
  let(:intake_pipeline) do
    IntakeFormPipeline ||= Class.new(Stretchy::Pipeline) do

      description "Ingests intake forms and scrubs ssn of html"
      
      processor :csv, 
        field: :vitals, 
        target_fields: [:heart_rate, :systolic, :diastolic],
        trim: true
        
      processor :script, 
        description: "Extracts first and last name from name field",
        lang: "painless",
        source: <<~PAINLESS
            ctx['name'] = /^[\\w\\s]+\\.\\s/.matcher(ctx['name']).replaceAll("");
            String[] parts = /\\s+/.split(ctx['name']);
            ctx['first_name'] = parts[0];
            if (parts.length > 1) {
              ctx['last_name'] = parts[1];
            }
        PAINLESS
        
      processor :html_strip, field: :ssn
      processor :convert, field: :systolic, type: :integer
      processor :convert, field: :diastolic, type: :integer
      processor :convert, field: :heart_rate, type: :integer

      processor :remove, field: :name
      processor :remove, field: :vitals
    
    end
  end

  let(:intake_form) do
    IntakeForm ||= Class.new(StretchyModel) do
      attribute :first_name, :keyword
      attribute :last_name, :keyword
      attribute :ssn, :keyword
      attribute :heart_rate, :integer
      attribute :systolic, :integer
      attribute :diastolic, :integer
      attribute :age, :integer
    
      default_pipeline :intake_form_pipeline
    end
  end

  let(:initial_data) do
    10.times.map do
      {
        "id" => Faker::Alphanumeric.alphanumeric(number: 7),
        "vitals" => [Faker::Number.between(from: 54, to: 120), Faker::Number.between(from: 60, to: 140), Faker::Number.between(from: 40, to: 100)].join(","),
        "name" => Faker::Name.name,
        "age" => Faker::Number.between(from: 19, to: 84),
        "ssn" => "<b>#{Faker::IDNumber.valid}</b>"
      }
    end 
  end

  let(:bulk_records) do
    initial_data.map do |data|
      { index: { _index: 'intake_forms', _id: data["id"], data: data } }
    end
  end

  let(:source_records) do
    initial_data.map do |data|
      { _source: data }
    end
  end

  before do
    intake_pipeline.create!
    intake_form.create_index!

    intake_form.bulk(bulk_records)
    intake_form.refresh_index!
  end

  after do
    intake_form.delete_index!
    intake_pipeline.delete!
  end

  it 'simulates the pipeline' do
    response = intake_pipeline.simulate(source_records)
    statuses = response["docs"].map {|d| d["processor_results"].map {|pr| pr["status"]}}.flatten
    expect(statuses).to all(eq("success"))
  end

  it 'processes data correctly' do
    expect(intake_pipeline.exists?).to be_truthy
    expect(intake_form.default_pipeline).to eq('intake_form_pipeline')
    expect(intake_form.count).to eq(initial_data.size)
    intake_form.all.each_with_index do |form, index|
      name = initial_data[index]["name"].gsub(/^[\w\s]+\.\s/, '')
      expect(form.first_name).to eq(name.split(' ')[0])
      expect(form.last_name).to eq(name.split(' ')[1])
      expect(form.ssn).not_to include('<b>', '</b>')
      expect(form.ssn).to eq(initial_data[index]["ssn"].gsub(/<\/?[^>]*>/, ""))
      expect(form.heart_rate).to eq(initial_data[index]["vitals"].split(',')[0].to_i) 
      expect(form.systolic).to eq(initial_data[index]["vitals"].split(',')[1].to_i)
      expect(form.diastolic).to eq(initial_data[index]["vitals"].split(',')[2].to_i)
      expect(form.age).to eq(initial_data[index]["age"])
    end

  end

  it 'appears in the pipeline list' do
    expect(intake_pipeline.all).to be_a(Hash)
    expect(intake_pipeline.all).to have_key('intake_form_pipeline')
  end

  it 'exists' do
    expect(intake_pipeline.exists?).to be_truthy
  end
end