require 'spec_helper'

describe Stretchy::Relations::QueryMethods::Match do

  describe Stretchy::Relations::QueryBuilder do
    let(:attribute_types) { double('model', attribute_types: { "path": Stretchy::Attributes::Type::Text.new })}

    before do
      allow(attribute_types).to receive(:[])
    end

    context 'query structure' do
      subject { described_class.new(values, attribute_types) }

      context 'without a match query' do
        let(:values) { { where: { first_name: 'Irving' } } }

        it 'match is not present' do
          expect(subject.send(:build_query).has_key?(:match)).to be_falsey
        end
      end

      context 'with a match query' do
        let(:values) { { match: { path: 'attributes/types' } } }

        it 'builds the query structure' do
          expect(subject.send(:build_query)).to eq({ match: { path: 'attributes/types' } }.with_indifferent_access)
        end
      end
    end



  end
  

end