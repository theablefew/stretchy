# [:where, :order, :field, :highlight, :source,
#     :must_not, :should, :query_string,
#     :aggregation, :search_option,
#     :filter, :or_filter, :extending, :skip_callbacks]

require "spec_helper"
require 'models/resource'


describe "QueryMethods" do

    describe Resource do 

        context 'querying' do
            before(:each) do
                # described_class.delete_index! if described_class.index_exists?
                records =  [
                    {"name": "John Doe", "email": "john@example.com", "phone": "123-456-7890", "position": {"name": "Software Engineer", "level": "Senior"}, "gender": "male", "age": 30, "income": 100000, "income_after_raise": 0},
                    {"name": "Jane Smith", "email": "jane@example.com", "phone": "987-654-3210", "position": {"name": "Product Manager", "level": "Senior"}, "gender": "female", "age": 35, "income": 120000, "income_after_raise": 0},
                    {"name": "Michael Johnson", "email": "michael@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Senior"}, "gender": "male", "age": 40, "income": 150000, "income_after_raise": 0},
                    {"name": "Emily Davis", "email": "emily@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Senior"}, "gender": "female", "age": 28, "income": 90000, "income_after_raise": 0},
                    {"name": "Olivia Wilson", "email": "olivia@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Junior"}, "gender": "female", "age": 32, "income": 80000, "income_after_raise": 0},
                    {"name": "Daniel Taylor", "email": "daniel@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Junior"}, "gender": "male", "age": 38, "income": 100000, "income_after_raise": 0},
                    {"name": "Sophia Anderson", "email": "sophia@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Junior"}, "gender": "female", "age": 27, "income": 85000, "income_after_raise": 0},
                    {"name": "Matthew Martinez", "email": "matthew@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Senior"}, "gender": "male", "age": 33, "income": 110000, "income_after_raise": 0},
                    {"name": "Ava Thomas", "email": "ava@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Senior"}, "gender": "female", "age": 30, "income": 120000, "income_after_raise": 0},
                    {"name": "Christopher Clark", "email": "christopher@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Senior"}, "gender": "male", "age": 42, "income": 140000, "income_after_raise": 0},
                    {"name": "Mia Rodriguez", "email": "mia@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Senior"}, "gender": "female", "age": 29, "income": 95000, "income_after_raise": 0},
                    {"name": "Andrew Walker", "email": "andrew@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Junior"}, "gender": "male", "age": 26, "income": 80000, "income_after_raise": 0},
                    {"name": "Isabella Lewis", "email": "isabella@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Junior"}, "gender": "female", "age": 31, "income": 90000, "income_after_raise": 0},
                    {"name": "Joshua Hall", "email": "joshua@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Junior"}, "gender": "male", "age": 37, "income": 100000, "income_after_raise": 0},
                    {"name": "Sophie Young", "email": "sophie@example.com", "phone": "555-987-6543", "position": {"name": "UX Designer", "level": "Junior"}, "gender": "female", "age": 24, "income": 75000, "income_after_raise": 0},
                    {"name": "Joseph Turner", "email": "joseph@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Senior"}, "gender": "male", "age": 34, "income": 120000, "income_after_raise": 0},
                    {"name": "Chloe Harris", "email": "chloe@example.com", "phone": "555-654-3210", "position": {"name": "Product Manager", "level": "Senior"}, "gender": "female", "age": 33, "income": 130000, "income_after_raise": 0},
                    {"name": "David Turner", "email": "david@example.com", "phone": "555-123-4567", "position": {"name": "Data Scientist", "level": "Senior"}, "gender": "male", "age": 39, "income": 150000, "income_after_raise": 160000},
                    {"name": "Emma Allen", "email": "emma@example.com", "phone": "555-987-6543", "position": {"name": "CEO", "level": "Senior"}, "gender": "female", "age": 26, "income": 200000, "income_after_raise": 250000} 
                ]
                described_class.bulk_in_batches(records, size: 100) do |batch|
                    batch.map! { |record| described_class.new(record).to_bulk }
                end
            end
    
            after(:each) do
                described_class.delete_index! if described_class.index_exists?
            end

            context 'counting' do
                it 'with a query' do
                    count = described_class.where(gender: :female).count
                    expect(count).to be_a(Integer)
                    expect(count).to eq(10)
                end

                it 'with a filter' do
                    count = described_class.filter(:terms, gender: [:female]).count
                    expect(count).to be_a(Integer)
                    expect(count).to eq(10)
                end

                it 'responds to count without a query' do
                    expect(described_class.count).to be_a(Integer)
                    expect(described_class.count).to eq(19)
                end
            end

            context '.where' do
                let(:subject) { 
                    described_class.create({"name": "David Brown", "email": "david@example.com", "phone": "555-456-7890", "position": {"name": "Software Engineer", "level": "Junior"}, "gender": "male", "age": 25, "income": 80000, "income_after_raise": 90000})
                }
                it 'returns resources with matching attributes' do
                    r = subject
                    described_class.refresh_index!
                    expect(described_class.where(age: 25).map(&:id)).to include(r.id)
                    r.delete
                end
            end

            context '.must_not' do
                it 'returns resources without the specified attribute' do
                    expect(described_class.must_not(gender: 'male').map(&:id)).not_to include(subject.id)
                end
                 
                it 'is aliased as .where_not' do
                    expect(described_class.where_not(gender: 'male').map(&:id)).not_to include(subject.id)
                end
            end

            context '.should' do
                it 'returns resources with the specified attribute' do
                    expect(described_class.should(age: 33).map(&:age)).to all(eq(33))
                end
            end

            context '.filter' do
                it 'filters by term' do
                    expect(described_class.filter(:term,  gender: 'male').map(&:gender)).to all(eq('male'))
                    expect(described_class.filter(:term,  gender: 'female').map(&:gender)).to all(eq('female'))
                end

                it 'filters by range' do
                    expect(described_class.filter(:range,  age: {gte: 30}).map(&:age)).to all(be >= 30)
                    expect(described_class.filter(:range,  age: {lte: 30}).map(&:age)).to all(be <= 30)
                end

                it 'filters by terms' do
                    expect(described_class.filter(:terms, 'position.name.keyword': ['Software Engineer', 'Product Manager']).map{|r| r.position['name']}).to all(be_in(['Software Engineer', 'Product Manager']))
                end
            
                it 'filters by exists' do
                    expect(described_class.filter(:exists, field: 'position.level').map{|r| r.position['level']}).to all(be_truthy)
                end

                # Doesn't seem to be supported in 7.x+
                xit 'filters by or' do
                    expect(described_class.filter(:or, [{term: {age: 25}}, {term: {age: 30}}]).map(&:age)).to all(include(25,30))
                end

                # Doesn't seem to be supported in 7.x+
                xit 'filters by not' do
                    expect(described_class.filter(:not, {term: {age: 25}}).map(&:age)).not_to include(25)
                end
            end


            context 'finding' do
                it 'returns the first resource' do
                    first_resource = described_class.create({"created_at": 2.years.ago, "name": "Chuck Founder", "email": "chuck@example.com", "phone": "555-456-2093", "position": {"name": "Software Engineer", "level": "Junior"}, "gender": "male", "age": 55})
                    described_class.refresh_index!
                    expect(described_class.first.id).to eq(first_resource.id)
                end

                it 'returns the last resource' do
                    last_resource = described_class.create({"name": "Buck Finale", "email": "buck@example.com", "phone": "555-456-2093", "position": {"name": "Software Engineer", "level": "Junior"}, "gender": "male", "age": 55})
                    described_class.refresh_index!
                    expect(described_class.last.id).to eq(last_resource.id)
                    last_resource.delete
                end
            end

            context 'routing' do
                xit 'returns resources with matching routing' do
                    expect(described_class.routing('123').first).to be_a(described_class)
                end
            end

            context 'query string' do
                it 'filter with query string' do
                    result = described_class.filter(:query_string, {query: "Mia OR Isabella", default_field: "name"} )
                    expect(result.map(&:name)).to include("Mia Rodriguez", "Isabella Lewis")
                end

                it 'returns hits' do
                    result = described_class.query_string("gender:male", default_field: "name")
                    expect(result.map(&:gender)).to all(eq('male') )
                end
            end

            context 'sorting' do

                it 'accepts fields as keyword arguments' do
                    result = described_class.order(age: :desc, name: :asc, created_at: {order: :desc, mode: :avg})
                    expected = {:sort=>[{:age=>:desc}, {:name=>:asc}, {:created_at=>{:order=>:desc, :mode=>:avg}}]}
                    expect(result.to_elastic).to eq(expected.with_indifferent_access)
                end

                it 'is aliased as sort' do
                    result = described_class.sort(age: :desc)
                    expected = {:sort=>[{:age=>:desc}]}
                    expect(result.to_elastic).to eq(expected.with_indifferent_access)
                end
            end

            context 'fields' do
                it 'returns only the specified fields' do
                    result = described_class.fields(:id, :name, :email)
                    expected = {:fields=>[:id, :name, :email]}
                    expect(result.to_elastic).to eq(expected.with_indifferent_access)
                end
            end

            context 'source' do

                it 'returns only the specified fields' do
                    result = described_class.source(includes: [:name, :email])
                    expected = {:_source=>{:includes=>[:name, :email]}}
                    expect(result.to_elastic).to eq(expected.with_indifferent_access)
                end
            end

            context 'highlight' do
                it 'returns highlighted fields' do
                    result = described_class.highlight(:body)
                    expected = {:highlight=>{:fields=>{body: {}}}}
                    expect(result.to_elastic).to eq(expected.with_indifferent_access)
                end
            end

        end
    end
end