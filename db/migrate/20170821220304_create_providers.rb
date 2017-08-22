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
      t.decimal :average_covered_charges, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :average_total_payments, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :average_medicare_payments, :precision => 10, :scale => 2, :default => 0.0
      t.timestamps
    end
  end
end
