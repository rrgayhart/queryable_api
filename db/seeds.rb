require 'csv'
require 'open-uri'
url = 'https://s3-us-west-2.amazonaws.com/bain-coding-challenge/Inpatient_Prospective_Payment_System__IPPS__Provider_Summary_for_the_Top_100_Diagnosis-Related_Groups__DRG__-_FY2011.csv'

@provider_header_attribute_pairs = {}

def populate_header_attribute_pairs(provider, row)
  provider.attributes.keys.each do |provider_attr|
    csv_match = row.headers.find do |header| 
        provider_attr.titlecase === header.strip
    end
    @provider_header_attribute_pairs[provider_attr] = csv_match if csv_match
  end
end

# Depending on Heroku speed - may need to use Rails.root.join('data', 'data_subset.csv')
# And source control actual csv

CSV.foreach(open(url), headers: true) do |row|
  provider = Provider.new()
  populate_header_attribute_pairs(provider, row) if @provider_header_attribute_pairs.empty?
  @provider_header_attribute_pairs.each { |k, v| provider[k] = row[v] }
  provider.save
  puts provider.id
end