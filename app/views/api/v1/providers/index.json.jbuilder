json.meta do
  json.total @providers.count
  json.max_shown @showing
  json.page @page
end

json.data @providers do |provider|
  json.key_format! :titlecase
  json.(provider, :provider_name, :provider_street_address, :provider_city, :provider_state, :provider_zip_code, :hospital_referral_region_description, :total_discharges)
  json.average_covered_charges number_to_currency(provider.average_covered_charges)
  json.average_total_payments number_to_currency(provider.average_total_payments)
  json.average_medicare_payments number_to_currency(provider.average_medicare_payments)
end