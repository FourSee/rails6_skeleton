# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_13_065822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "consents", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "title_translations"
    t.jsonb "content_translations"
    t.citext "key", null: false
    t.index ["key"], name: "index_consents_on_key", unique: true
    t.index ["uuid"], name: "index_consents_on_uuid", unique: true
  end

  create_table "user_consents", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "consent_id"
    t.boolean "consented", default: false, null: false
    t.boolean "up_to_date", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consent_id", "user_id", "consented", "up_to_date"], name: "consented_to_index", where: "((consented = true) AND (up_to_date = true))"
    t.index ["consent_id"], name: "index_user_consents_on_consent_id"
    t.index ["consented", "up_to_date", "user_id", "id"], name: "valid_consents", where: "((consented = true) AND (up_to_date = true))"
    t.index ["user_id"], name: "index_user_consents_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password"
    t.string "encrypted_email_iv"
    t.string "encrypted_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_preferred_name_iv"
    t.string "encrypted_preferred_name"
    t.string "encrypted_username_iv"
    t.string "encrypted_username"
    t.uuid "uuid"
    t.string "email_bidx"
    t.index ["email_bidx"], name: "index_users_on_email_bidx", unique: true
    t.index ["id", "encrypted_email", "encrypted_email_iv"], name: "user_email"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
