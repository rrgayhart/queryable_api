require 'rails_helper'

describe 'Providers API' do
  it 'returns a list of providers' do
    create_list(:provider, 3)
    get '/api/v1/providers'
    expect(response).to be_success
    providers = JSON.parse(response.body)['data']
    expect(providers.count).to eq(3)
  end

  it 'returns the correctly formatted provider params' do
    create(:provider)
    get '/api/v1/providers'
    providers = JSON.parse(response.body)
    expected_response =   {
      "Provider Name" => "SOUTHEAST ALABAMA MEDICAL CENTER",
      "Provider Street Address" => "1108 ROSS CLARK CIRCLE",
      "Provider City" => "DOTHAN",
      "Provider State" => "AL",
      "Provider Zip Code" => "36301", 
      "Hospital Referral Region Description" => "AL - Dothan",
      "Total Discharges" => 91,
      "Average Covered Charges" => "$32,963.07", 
      "Average Total Payments" =>   "$5,777.24",
      "Average Medicare Payments" => "$4,763.73"
    }
    expect(providers['data'].first).to eq(expected_response)
  end

  it 'returns meta data' do
    create_list(:provider, 3)
    get '/api/v1/providers'
    meta = JSON.parse(response.body)['meta']
    expect(meta['total']).to eq(3)
    expect(meta['max_shown']).to eq(100)
    expect(meta['page']).to eq('1')
  end

  context 'with pagination' do
    before do
      create_list(:provider, 101)
    end
    
    it 'paginates responses' do
      get '/api/v1/providers'
      body = JSON.parse(response.body)
      meta = body['meta']
      providers = body['data']
      expect(meta['total']).to eq(101)
      expect(meta['max_shown']).to eq(100)
      expect(meta['page']).to eq('1')
      expect(providers.count).to eq(100)
    end

    it 'responds to pages' do
      get '/api/v1/providers?page=2'
      body = JSON.parse(response.body)
      meta = body['meta']
      providers = body['data']
      expect(meta['total']).to eq(101)
      expect(meta['max_shown']).to eq(100)
      expect(meta['page']).to eq('2')
      expect(providers.count).to eq(1)
    end
  end

  context ('with complex query params') {
    before do
      states = ['GA', 'VA', 'VA', 'MA', 'OR', 'ny', 'ny', 'ga', 'CA', 'PA']
      10.times do |i|
        create(:provider, {
          total_discharges: (i * 100),
          average_covered_charges: "#{(i * 100)}.#{(i)}0",
          average_medicare_payments: "#{(i * 100) + 1}.#{(i)}0",
          provider_state: states[i]
        })
      end
    end

    it 'calculates max_discharges' do
      get '/api/v1/providers?max_discharges=500'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Total Discharges']}).to eq([0, 100, 200, 300, 400, 500])
      expect(providers.count).to eq(6)
    end

    it 'calculates min_discharges' do
      get '/api/v1/providers?min_discharges=500'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Total Discharges']}).to eq([500, 600, 700, 800, 900])
      expect(providers.count).to eq(5)
    end

    it 'calculates max_average_covered_charges' do
      get '/api/v1/providers?max_average_covered_charges=500'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Average Covered Charges']}).to eq(["$0.00", "$100.10", "$200.20", "$300.30", "$400.40"])
      expect(providers.count).to eq(5)
    end

    it 'calculates min_average_covered_charges' do
      get '/api/v1/providers?min_average_covered_charges=500'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Average Covered Charges']}).to eq(["$500.50", "$600.60", "$700.70", "$800.80", "$900.90"])
      expect(providers.count).to eq(5)
    end

    it 'calculates max_average_medicare_payments' do
      get '/api/v1/providers?max_average_medicare_payments=501'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Average Medicare Payments']}).to eq(["$1.00", "$101.10", "$201.20", "$301.30", "$401.40"])
      expect(providers.count).to eq(5)
    end

    it 'calculates min_average_medicare_payments' do
      get '/api/v1/providers?min_average_medicare_payments=501'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Average Medicare Payments']}).to eq(["$501.50", "$601.60", "$701.70", "$801.80", "$901.90"])
      expect(providers.count).to eq(5)
    end

    it 'pulls state data' do
      get '/api/v1/providers?state=ga'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Provider State']}).to eq(["GA", "ga"])
      expect(providers.count).to eq(2)
    end

    it 'handles multiple queries' do
      get '/api/v1/providers?min_average_medicare_payments=501&state=ga'
      providers = JSON.parse(response.body)['data']
      expect(providers.map{|p| p['Provider State']}).to eq(["ga"])
      expect(providers.map{|p| p['Average Medicare Payments']}).to eq(["$701.70"])
      expect(providers.count).to eq(1)
    end

    it 'returns an error for invalid state data' do
      get '/api/v1/providers?state=gafasdfefs'
      providers = JSON.parse(response.body)['data']
      expect(response.status).to be(400)
      expect(response.body).to eq("{\"error\":\"state param invalid\"}")
    end

    it 'returns an error for invalid numeric data' do
      get '/api/v1/providers?min_average_medicare_payments=gafasdfefs'
      providers = JSON.parse(response.body)['data']
      expect(response.status).to be(400)
      expect(response.body).to eq("{\"error\":\"min_average_medicare_payments param invalid\"}")
    end
  }
end