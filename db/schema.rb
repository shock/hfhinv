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

ActiveRecord::Schema.define(version: 20180329142133) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "items_count", default: 0, null: false
  end

  create_table "donations", force: :cascade do |t|
    t.date "date_of_contact"
    t.string "info_collected_by"
    t.date "pickup_date"
    t.boolean "call_first", default: false
    t.boolean "email_receipt", default: false
    t.text "special_instructions"
    t.integer "donor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "pickup"
    t.integer "items_count", default: 0, null: false
  end

  create_table "donors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "phone2"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "longitude"
    t.float "latitude"
    t.integer "donations_count", default: 0, null: false
  end

  create_table "item_types", force: :cascade do |t|
    t.string "name"
    t.integer "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.string "notes"
    t.integer "items_count", default: 0, null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer "item_type_id"
    t.decimal "regular_price", precision: 8, scale: 2
    t.decimal "sale_price", precision: 8, scale: 2
    t.date "date_received"
    t.date "date_sold"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rejected", default: false
    t.string "rejection_reason"
    t.integer "donation_id"
    t.string "inventory_number"
    t.string "description"
    t.integer "use_of_item_id"
    t.integer "flags", default: 0, null: false
  end

  create_table "system_states", force: :cascade do |t|
    t.string "name"
    t.text "serial_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "use_of_items", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "items_count", default: 0, null: false
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string "zipcode"
    t.string "city"
    t.string "state"
    t.string "county"
    t.float "longitude"
    t.float "latitude"
    t.integer "timezone_offset"
    t.boolean "timezone_dst"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "timezone"
    t.index ["zipcode"], name: "zipcode"
  end

end
