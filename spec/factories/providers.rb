FactoryGirl.define do
  factory :provider do
    provider_name "SOUTHEAST ALABAMA MEDICAL CENTER"
    provider_street_address "1108 ROSS CLARK CIRCLE"
    provider_city "DOTHAN"
    provider_state "AL"
    provider_zip_code "36301"
    hospital_referral_region_description "AL - Dothan"
    total_discharges 91
    average_covered_charges "$32,963.07"
    average_total_payments "$5,777.24"
    average_medicare_payments "$4,763.73"
  end
end