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

ActiveRecord::Schema.define(version: 2022_08_29_080612) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

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
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "chat_groups", force: :cascade do |t|
    t.string "title"
    t.string "chat_id"
    t.boolean "is_active", default: true
    t.text "reason"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "program_id"
    t.string "chat_type", default: "group"
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

  create_table "email_notifications", force: :cascade do |t|
    t.integer "milestone_id"
    t.integer "message_id"
    t.text "emails", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_milestones", force: :cascade do |t|
    t.string "event_uuid"
    t.integer "milestone_id"
    t.integer "submitter_id"
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_shareds", force: :cascade do |t|
    t.string "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "program_id"
  end

  create_table "event_type_shareds", force: :cascade do |t|
    t.integer "event_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "program_id"
  end

  create_table "event_type_webhooks", force: :cascade do |t|
    t.integer "event_type_id"
    t.integer "webhook_id"
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
    t.string "code"
    t.string "guideline"
  end

  create_table "events", primary_key: "uuid", id: :string, limit: 36, force: :cascade do |t|
    t.integer "event_type_id"
    t.integer "creator_id"
    t.integer "program_id"
    t.string "location_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "close", default: false
    t.string "link_uuid"
    t.datetime "event_date"
    t.datetime "deleted_at"
    t.datetime "lockable_at"
    t.integer "conclude_event_type_id"
    t.string "referrer"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
  end

  create_table "field_options", force: :cascade do |t|
    t.integer "field_id"
    t.string "name"
    t.string "value"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "display_order", default: 0
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
    t.string "type"
  end

  create_table "fields", force: :cascade do |t|
    t.string "code"
    t.string "name"
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
    t.boolean "color_required", default: false
    t.text "validations"
    t.boolean "tracking", default: false
    t.text "description"
    t.integer "section_id"
    t.string "relevant"
    t.integer "mapping_field_id"
    t.string "template_file"
    t.string "template_name"
    t.boolean "is_milestone_datetime", default: false
    t.integer "milestone_datetime_order"
  end

  create_table "follow_ups", force: :cascade do |t|
    t.string "event_id"
    t.integer "follower_id"
    t.integer "followee_id"
    t.text "message"
    t.string "channels", default: [], array: true
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

  create_table "medisies", force: :cascade do |t|
    t.string "url"
    t.string "name"
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medisys_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medisys_countries", force: :cascade do |t|
    t.string "code"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "medisys_feeds", force: :cascade do |t|
    t.string "title"
    t.string "link"
    t.string "description"
    t.string "keywords"
    t.datetime "pub_date"
    t.string "guid"
    t.string "iso_language"
    t.string "georss_point"
    t.integer "medisy_id"
    t.string "category_trigger"
    t.string "source_name"
    t.string "source_url"
    t.integer "medisys_country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fail_reason"
    t.integer "program_id"
  end

  create_table "medisys_feeds_categories", force: :cascade do |t|
    t.integer "medisys_feed_id"
    t.integer "medisys_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "message"
    t.integer "milestone_id"
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
    t.boolean "final", default: false
    t.integer "creator_id"
    t.boolean "verified", default: false
    t.integer "status"
  end

  create_table "notification_chat_groups", force: :cascade do |t|
    t.integer "notification_id"
    t.integer "chat_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "milestone_id"
    t.text "message"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "message_id"
  end

  create_table "program_telegram_notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "program_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creator_id"
    t.string "language_code"
    t.boolean "enable_email_notification", default: false
    t.integer "unlock_event_duration", default: 7
    t.string "logo"
    t.integer "national_zoom_level", default: 7
    t.integer "provincial_zoom_level", default: 10
    t.string "risk_assessment_guideline"
  end

  create_table "schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "enabled", default: true
    t.text "message"
    t.integer "interval_type"
    t.integer "interval_value"
    t.integer "date_index"
    t.integer "follow_up_hour"
    t.text "emails", default: [], array: true
    t.string "channels", default: [], array: true
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deadline_duration_in_day"
  end

  create_table "sections", force: :cascade do |t|
    t.string "name"
    t.integer "milestone_id"
    t.integer "display_order"
    t.boolean "default", default: false
    t.boolean "display", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telegram_bots", force: :cascade do |t|
    t.string "token"
    t.string "username"
    t.boolean "enabled", default: false
    t.boolean "actived", default: false
    t.integer "program_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "template_fields", force: :cascade do |t|
    t.integer "template_id"
    t.integer "field_id"
    t.integer "display_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string "name"
    t.integer "program_id"
    t.text "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracings", force: :cascade do |t|
    t.integer "field_id"
    t.string "field_value"
    t.text "properties"
    t.string "traceable_id"
    t.string "traceable_type"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "province_code"
    t.string "full_name"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "phone_number"
    t.string "telegram_chat_id"
    t.string "telegram_username"
    t.string "notification_channels", default: [], array: true
    t.string "locale", default: "km"
    t.integer "sign_in_type", default: 1
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.string "username"
    t.string "password"
    t.string "url"
    t.string "type"
    t.integer "program_id"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
