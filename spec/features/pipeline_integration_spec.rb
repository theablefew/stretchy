require 'spec_helper'
require 'faker'

describe 'Ingest Pipeline' do
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
            String name = ctx['name'];
            int index = name.indexOf('. ');
            if (index >= 0) {
              name = name.substring(index + 2);
            }
            String[] parts = /\\s+/.split(name);
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
    
      default_pipeline :intake_form_pipeline
    end
  end

  let(:initial_data) do
    10.times.map do
      {
        "id" => Faker::Alphanumeric.alphanumeric(number: 7),
        "vitals" => [Faker::Number.number(digits: 3), Faker::Number.number(digits: 2), Faker::Number.number(digits: 2)].join(","),
        "name" => Faker::Name.name,
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
    intake_pipeline.new.create
    intake_form.create_index!

    IntakeForm.bulk(bulk_records)
    IntakeForm.refresh_index!
  end

  after do
    IntakeForm.all.pluck(:first_name)
    intake_pipeline.new.delete
    intake_form.delete_index!
  end

  it 'simulates the pipeline' do
    response = intake_pipeline.new.simulate(source_records)
    statuses = response["docs"].map {|d| d["processor_results"].map {|pr| pr["status"]}}.flatten
    expect(statuses).to all(eq("success"))
  end

  it 'processes data correctly' do
    expect(intake_pipeline.new.exists?).to be_truthy
    expect(intake_form.default_pipeline).to eq('intake_form_pipeline')
    expect(IntakeForm.count).to eq(initial_data.size)
    IntakeForm.all.each_with_index do |form, index|
      name = initial_data[index]["name"].gsub(/^\w+\.\s/, '')
      expect(form.first_name).to eq(name.split(' ')[0])
      expect(form.last_name).to eq(name.split(' ')[1])
      expect(form.ssn).not_to include('<b>', '</b>')
      expect(form.ssn).to eq(initial_data[index]["ssn"].gsub(/<\/?[^>]*>/, ""))
      expect(form.heart_rate).to eq(initial_data[index]["vitals"].split(',')[0].to_i) 
      expect(form.systolic).to eq(initial_data[index]["vitals"].split(',')[1].to_i)
      expect(form.diastolic).to eq(initial_data[index]["vitals"].split(',')[2].to_i)
    end
  end
end