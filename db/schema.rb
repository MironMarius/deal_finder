# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_16_112110) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "deal_locations", force: :cascade do |t|
    t.bigint "deal_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deal_id"], name: "index_deal_locations_on_deal_id"
    t.index ["location_id"], name: "index_deal_locations_on_location_id"
  end

  create_table "deals", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.float "original_price"
    t.float "discount_price"
    t.float "discount_percentage"
    t.string "category"
    t.string "subcategory"
    t.string "tags", array: true
    t.string "merchant_name"
    t.float "merchant_rating"
    t.integer "quantity_sold"
    t.date "expiry_date"
    t.boolean "featured_deal"
    t.string "image_url"
    t.text "fine_print"
    t.integer "review_count"
    t.float "average_rating"
    t.integer "available_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address"], name: "index_locations_on_address", unique: true
  end

  add_foreign_key "deal_locations", "deals"
  add_foreign_key "deal_locations", "locations"
end
