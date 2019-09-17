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

ActiveRecord::Schema.define(version: 2019_09_17_021102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "client_apps", force: :cascade do |t|
    t.string "name"
    t.string "access_token"
    t.string "ip_address"
    t.boolean "active", default: true
    t.string "permissions", array: true
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_milestones", force: :cascade do |t|
    t.string "event_uuid"
    t.integer "milestone_id"
    t.integer "submitter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id"
    t.integer "program_id"
    t.boolean "shared"
    t.string "color"
    t.boolean "default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", primary_key: "uuid", id: :string, limit: 36, force: :cascade do |t|
    t.integer "event_type_id"
    t.integer "creator_id"
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "field_options", force: :cascade do |t|
    t.integer "field_id"
    t.string "name"
    t.string "value"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "field_values", force: :cascade do |t|
    t.integer "field_id"
    t.string "field_code"
    t.string "value"
    t.string "color"
    t.text "values", array: true
    t.text "properties"
    t.string "image"
    t.string "file"
    t.string "valueable_id"
    t.string "valueable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fields", force: :cascade do |t|
    t.string "code"
    t.string "name", null: false
    t.string "field_type"
    t.boolean "required"
    t.string "mapping_field"
    t.string "mapping_field_type"
    t.integer "display_order"
    t.integer "milestone_id"
    t.boolean "is_default", default: false
    t.boolean "entry_able", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", primary_key: "code", id: :string, force: :cascade do |t|
    t.string "name_en", null: false
    t.string "name_km", null: false
    t.string "kind", null: false
    t.string "parent_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "milestones", force: :cascade do |t|
    t.integer "program_id"
    t.string "name"
    t.integer "display_order"
    t.boolean "is_default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telegram_groups", force: :cascade do |t|
    t.string "title"
    t.integer "chat_id"
    t.boolean "is_active"
    t.text "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telegram_notifications", force: :cascade do |t|
    t.integer "milestone_id"
    t.string "chat_ids", array: true
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telegram_notifications_groups", force: :cascade do |t|
    t.integer "telegram_notification_id"
    t.integer "telegram_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: ""
    t.integer "role", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "program_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
