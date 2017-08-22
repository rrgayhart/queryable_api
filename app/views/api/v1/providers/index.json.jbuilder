json.data @providers do |provider|
  json.key_format! :titlecase
  json.(provider, :provider_name, :provider_street_address, :provider_city, :provider_state, :provider_zip_code, :hospital_referral_region_description, :total_discharges, :average_covered_charges, :average_total_payments, :average_medicare_payments)
end