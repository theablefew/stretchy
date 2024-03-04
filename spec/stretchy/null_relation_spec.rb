require 'spec_helper'

describe Stretchy::NullRelation do
    let (:subject) { Stretchy::Relation.extend Stretchy::NullRelation }

    it 'returns an empty array for pluck' do
        expect(subject.pluck).to eq([])
    end

    it 'returns 0 for delete_all' do
        expect(subject.delete_all).to eq(0)
    end

    it 'returns 0 for update_all' do
        expect(subject.update_all({})).to eq(0)
    end

    it 'returns 0 for delete' do
        expect(subject.delete(1)).to eq(0)
    end

    it 'returns true for empty?' do
        expect(subject.empty?).to eq(true)
    end

    it 'returns true for none?' do
        expect(subject.none?).to eq(true)
    end

    it 'returns false for any?' do
        expect(subject.any?).to eq(false)
    end

    it 'returns false for one?' do
        expect(subject.one?).to eq(false)
    end

    it 'returns false for many?' do
        expect(subject.many?).to eq(false)
    end

    it 'returns false for exists?' do
        expect(subject.exists?).to eq(false)
    end

    it 'returns an OpenStruct for exec_queries' do
        expect(subject.exec_queries).to be_a(OpenStruct)
    end


end