class CreateZipCodeTable < ActiveRecord::Migration[5.1]
  def change
    create_table "zip_codes", force: true do |t|
      t.string   "zipcode"
      t.string   "city"
      t.string   "state"
      t.string   "county"
      t.float    "longitude"
      t.float    "latitude"
      t.integer  "timezone_offset"
      t.boolean  "timezone_dst"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "timezone"
    end

    add_index "zip_codes", ["zipcode"], name: "zipcode", using: :btree
  end
end
