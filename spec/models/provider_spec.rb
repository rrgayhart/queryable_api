require 'rails_helper'

RSpec.describe Provider, type: :model do
  it { should validate_presence_of(:provider_name) }

  describe 'scopes' do
    before do
      states = ['GA', 'VA', 'VA', 'MA', 'ga', 'ny', 'ny', 'OR', 'CA', 'PA']
      10.times do |i|
        money_increment = "#{(i * 100)}.#{(i)}0"
        create(:provider, {
          total_discharges: (i * 100),
          average_covered_charges: money_increment,
          average_medicare_payments: money_increment,
          provider_state: states[i]
        })
      end
    end

    describe 'max_discharges' do
      it 'returns inclusive max' do
        expect(Provider.max_discharges(0).length).to eq(1)
        expect(Provider.max_discharges(100).length).to eq(2)
        expect(Provider.max_discharges(100000).length).to eq(10)
      end
    end
    describe 'min_discharges' do
      it 'returns inclusive min' do
        expect(Provider.min_discharges(0).length).to eq(10)
        expect(Provider.min_discharges(100).length).to eq(9)
        expect(Provider.min_discharges(100000).length).to eq(0)
      end
    end
    describe 'max_average_covered_charges' do
      it 'returns inclusive max' do
        expect(Provider.max_average_covered_charges(500).length).to eq(5)
        expect(Provider.max_average_covered_charges(100).length).to eq(1)
        expect(Provider.max_average_covered_charges(1000).length).to eq(10)
      end
    end
    describe 'min_average_covered_charges' do
      it 'returns inclusive min' do
        expect(Provider.min_average_covered_charges(500).length).to eq(5)
        expect(Provider.min_average_covered_charges(100).length).to eq(9)
        expect(Provider.min_average_covered_charges(1000).length).to eq(0)
      end
    end
    describe 'max_average_medicare_payments' do
      it 'returns inclusive max' do
        expect(Provider.max_average_medicare_payments(500).length).to eq(5)
        expect(Provider.max_average_medicare_payments(100).length).to eq(1)
        expect(Provider.max_average_medicare_payments(1000).length).to eq(10)
      end
    end
    describe 'min_average_medicare_payments' do
      it 'returns inclusive min' do
        expect(Provider.min_average_medicare_payments(500).length).to eq(5)
        expect(Provider.min_average_medicare_payments(100).length).to eq(9)
        expect(Provider.min_average_medicare_payments(1000).length).to eq(0)
      end
    end

    describe 'state' do
      it 'filters by state' do
        expect(Provider.state('GA').length).to eq(2)
        expect(Provider.state('PA').length).to eq(1)
        expect(Provider.state('NV').length).to eq(0)
      end
    end
  end
end
