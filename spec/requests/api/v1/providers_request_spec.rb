require 'rails_helper'

describe 'Providers API' do
  it 'returns a list of providers' do
    create_list(:provider, 3)
    get '/api/v1/providers'
    expect(response).to be_success
    providers = JSON.parse(response.body)['data']
    expect(providers.count).to eq(3)
  end

  it 'returns the correctly formatted params' do
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

  it 'paginates responses' do

  end

  # it 'base example' do
  #   create(:provider)
  #   get '/api/v1/providers?max_discharges=5&min_discharges=6&max_average_covered_charges=50000
  #       &min_average_covered_charges=40000&min_average_medicare_payments=6000
  #       &max_average_medicare_payments=10000&state=GA'
  #   expect(response).to be_success
  # end
end