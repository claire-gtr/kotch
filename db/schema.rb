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

ActiveRecord::Schema.define(version: 2022_01_03_164239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subject_id", null: false
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_id"], name: "index_answers_on_subject_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lesson_id", null: false
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "used_credit", default: false
    t.boolean "messages_readed", default: false, null: false
    t.index ["lesson_id"], name: "index_bookings_on_lesson_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "employments", force: :cascade do |t|
    t.bigint "enterprise_id", null: false
    t.bigint "employee_id", null: false
    t.boolean "accepted"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_employments_on_employee_id"
    t.index ["enterprise_id"], name: "index_employments_on_enterprise_id"
  end

  create_table "friend_requests", force: :cascade do |t|
    t.integer "requestor_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "pending"
    t.index ["receiver_id"], name: "index_friend_requests_on_receiver_id"
    t.index ["requestor_id", "receiver_id"], name: "index_friend_requests_on_requestor_id_and_receiver_id", unique: true
    t.index ["requestor_id"], name: "index_friend_requests_on_requestor_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "friend_a_id", null: false
    t.integer "friend_b_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["friend_a_id", "friend_b_id"], name: "index_friendships_on_friend_a_id_and_friend_b_id", unique: true
    t.index ["friend_a_id"], name: "index_friendships_on_friend_a_id"
    t.index ["friend_b_id"], name: "index_friendships_on_friend_b_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.bigint "user_id"
    t.string "sport_type"
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "pending"
    t.bigint "location_id"
    t.boolean "public", default: false
    t.text "focus"
    t.integer "reccurency", default: 0, null: false
    t.boolean "active", default: false, null: false
    t.index ["location_id"], name: "index_lessons_on_location_id"
    t.index ["user_id"], name: "index_lessons_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "visible", default: false, null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "booking_id"
    t.bigint "lesson_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "readed", default: false, null: false
    t.index ["booking_id"], name: "index_messages_on_booking_id"
    t.index ["lesson_id"], name: "index_messages_on_lesson_id"
  end

  create_table "pack_orders", force: :cascade do |t|
    t.string "state"
    t.float "amount"
    t.bigint "user_id", null: false
    t.string "checkout_session_id"
    t.integer "credit_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_pack_orders_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "domain_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "coupon_code"
    t.integer "percentage"
  end

  create_table "promo_codes", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "uses_count", default: 0
  end

  create_table "reasons", force: :cascade do |t|
    t.string "title", null: false
    t.string "other_text"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_reasons_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "content"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_subjects_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "stripe_id"
    t.string "end_date"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nickname"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "user_codes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "promo_code_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["promo_code_id"], name: "index_user_codes_on_promo_code_id"
    t.index ["user_id"], name: "index_user_codes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "address"
    t.integer "gender"
    t.integer "sport_habits"
    t.integer "physical_pain"
    t.integer "level"
    t.integer "intensity"
    t.boolean "admin", default: false
    t.boolean "coach", default: false
    t.text "interests", default: [], array: true
    t.date "birth_date"
    t.integer "expectations"
    t.integer "credit_count", default: 0
    t.string "stripe_id"
    t.boolean "validated_coach", default: false
    t.boolean "terms", default: false
    t.boolean "optin_cgv", default: false
    t.boolean "promo_code_used", default: false, null: false
    t.string "referral_code", default: "", null: false
    t.integer "company_discover"
    t.integer "status", default: 0, null: false
    t.string "enterprise_name"
    t.string "enterprise_code"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "waiting_bookings", force: :cascade do |t|
    t.string "user_email", null: false
    t.bigint "lesson_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["lesson_id"], name: "index_waiting_bookings_on_lesson_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "subjects"
  add_foreign_key "answers", "users"
  add_foreign_key "bookings", "lessons"
  add_foreign_key "bookings", "users"
  add_foreign_key "employments", "users", column: "employee_id"
  add_foreign_key "employments", "users", column: "enterprise_id"
  add_foreign_key "lessons", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "messages", "bookings"
  add_foreign_key "messages", "lessons"
  add_foreign_key "pack_orders", "users"
  add_foreign_key "reasons", "users"
  add_foreign_key "subjects", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "user_codes", "promo_codes"
  add_foreign_key "user_codes", "users"
  add_foreign_key "waiting_bookings", "lessons"
end
