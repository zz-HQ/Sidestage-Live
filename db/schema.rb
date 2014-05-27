# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140527143451) do

  create_table "booking_offers", force: true do |t|
    t.integer  "booking_request_id"
    t.integer  "requestor_id"
    t.integer  "artist_id"
    t.integer  "price"
    t.boolean  "accepted"
    t.datetime "start_at"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "booking_offers", ["artist_id", "requestor_id"], name: "index_booking_offers_on_artist_id_and_requestor_id", using: :btree
  add_index "booking_offers", ["requestor_id", "artist_id"], name: "index_booking_offers_on_requestor_id_and_artist_id", using: :btree

  create_table "booking_requests", force: true do |t|
    t.integer  "requestor_id"
    t.integer  "artist_id"
    t.integer  "price"
    t.boolean  "accepted"
    t.datetime "start_at"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "booking_requests", ["artist_id", "requestor_id"], name: "index_booking_requests_on_artist_id_and_requestor_id", using: :btree
  add_index "booking_requests", ["requestor_id", "artist_id"], name: "index_booking_requests_on_requestor_id_and_artist_id", using: :btree

  create_table "genre_translations", force: true do |t|
    t.integer  "genre_id",   null: false
    t.string   "locale",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "genre_translations", ["genre_id"], name: "index_genre_translations_on_genre_id", using: :btree
  add_index "genre_translations", ["locale"], name: "index_genre_translations_on_locale", using: :btree

  create_table "genres", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "genres_profiles", id: false, force: true do |t|
    t.integer "genre_id"
    t.integer "profile_id"
  end

  add_index "genres_profiles", ["genre_id", "profile_id"], name: "index_genres_profiles_on_genre_id_and_profile_id", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.integer  "thread_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree
  add_index "messages", ["thread_id"], name: "index_messages_on_thread_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.string   "tagline"
    t.text     "description"
    t.text     "about"
    t.string   "youtube"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "soundcloud"
    t.text     "style"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "mobile"
    t.text     "social_media"
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",           default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "airmusic_name"
    t.string   "avatar"
    t.string   "city"
    t.integer  "unread_messages_counter"
    t.integer  "received_messages_counter"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
