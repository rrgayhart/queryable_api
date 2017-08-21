class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :provider_name
      t.string :provider_street_address
      t.string :provider_city
      t.string :provider_state
      t.string :provider_zip_code
      t.string :hospital_referral_region_description
      t.integer :total_discharges
      t.string :average_covered_charges
      t.string :average_total_payments
      t.string :average_medicare_payments
      t.timestamps
    end
  end
end
