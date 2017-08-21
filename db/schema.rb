# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170821220304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "providers", force: :cascade do |t|
    t.string "provider_name"
    t.string "provider_street_address"
    t.string "provider_city"
    t.string "provider_state"
    t.string "provider_zip_code"
    t.string "hospital_referral_region_description"
    t.integer "total_discharges"
    t.string "average_covered_charges"
    t.string "average_total_payments"
    t.string "average_medicare_payments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end