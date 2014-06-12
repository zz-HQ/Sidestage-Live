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

ActiveRecord::Schema.define(version: 20140612132937) do

  create_table "conversations", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "body"
    t.datetime "last_message_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["receiver_id"], name: "index_conversations_on_receiver_id", using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currencies", ["name"], name: "index_currencies_on_name", using: :btree

  create_table "currency_rates", force: true do |t|
    t.integer  "currency_id"
    t.string   "rate_from"
    t.string   "rate_to"
    t.float    "rate"
    t.float    "ask"
    t.float    "bid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currency_rates", ["currency_id"], name: "index_currency_rates_on_currency_id", using: :btree
  add_index "currency_rates", ["rate_from", "rate_to"], name: "index_currency_rates_on_rate_from_and_rate_to", using: :btree

  create_table "deals", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "message_id"
    t.integer  "profile_id"
    t.integer  "artist_id"
    t.integer  "customer_id"
    t.datetime "artist_accepted_at"
    t.datetime "customer_accepted_at"
    t.integer  "price"
    t.datetime "start_at"
    t.boolean  "offer"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_charge_id"
    t.integer  "charged_price"
    t.string   "currency"
  end

  add_index "deals", ["artist_id"], name: "index_deals_on_artist_id", using: :btree
  add_index "deals", ["conversation_id"], name: "index_deals_on_conversation_id", using: :btree
  add_index "deals", ["customer_id"], name: "index_deals_on_customer_id", using: :btree

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
    t.text     "body"
    t.datetime "read_at"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.string   "tagline"
    t.text     "description"
    t.text     "about"
    t.string   "youtube"
    t.string   "soundcloud"
    t.text     "style"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "solo",        default: true
    t.string   "location"
    t.boolean  "published",   default: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "mobile"
    t.text     "social_media"
    t.string   "airmusic_name"
    t.string   "avatar"
    t.string   "city"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unread_message_counter"
    t.string   "currency"
    t.string   "stripe_customer_id"
    t.string   "role"
    t.text     "about"
    t.boolean  "newsletter_subscribed",  default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
