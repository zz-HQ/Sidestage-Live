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

ActiveRecord::Schema.define(version: 20141220134454) do

  create_table "conversations", force: true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "body"
    t.datetime "last_message_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "sender_archived",   default: false
    t.boolean  "receiver_archived", default: false
  end

  add_index "conversations", ["receiver_id"], name: "index_conversations_on_receiver_id", using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "coupons", force: true do |t|
    t.datetime "expires_at"
    t.string   "code"
    t.text     "description"
    t.integer  "amount"
    t.string   "currency"
    t.boolean  "active",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deals_count"
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", using: :btree

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
    t.float    "rate",        limit: 24
    t.float    "ask",         limit: 24
    t.float    "bid",         limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "currency_rates", ["currency_id"], name: "index_currency_rates_on_currency_id", using: :btree
  add_index "currency_rates", ["rate_from", "rate_to"], name: "index_currency_rates_on_rate_from_and_rate_to", using: :btree

  create_table "deal_versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "deal_versions", ["item_type", "item_id"], name: "index_deal_versions_on_item_type_and_item_id", using: :btree

  create_table "deals", force: true do |t|
    t.integer  "conversation_id"
    t.integer  "profile_id"
    t.integer  "artist_id"
    t.integer  "customer_id"
    t.integer  "artist_price"
    t.datetime "start_at"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "balanced_debit_id"
    t.integer  "charged_price"
    t.string   "currency"
    t.string   "state"
    t.datetime "state_transition_at"
    t.boolean  "paid_out",            default: false
    t.string   "balanced_credit_id"
    t.integer  "coupon_id"
    t.string   "coupon_code"
    t.integer  "coupon_price"
    t.integer  "customer_price"
  end

  add_index "deals", ["artist_id"], name: "index_deals_on_artist_id", using: :btree
  add_index "deals", ["conversation_id"], name: "index_deals_on_conversation_id", using: :btree
  add_index "deals", ["coupon_id"], name: "index_deals_on_coupon_id", using: :btree
  add_index "deals", ["customer_id"], name: "index_deals_on_customer_id", using: :btree
  add_index "deals", ["state"], name: "index_deals_on_state", using: :btree

  create_table "event_invitations", force: true do |t|
    t.integer  "event_id"
    t.integer  "inviter_id"
    t.boolean  "invited"
    t.boolean  "visited"
    t.boolean  "accepted"
    t.boolean  "rejected"
    t.integer  "attendee_id"
    t.string   "email"
    t.string   "token"
    t.integer  "coupon_id"
    t.string   "coupon_price"
    t.string   "coupon_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_invitations", ["attendee_id"], name: "index_event_invitations_on_attendee_id", using: :btree
  add_index "event_invitations", ["event_id"], name: "index_event_invitations_on_event_id", using: :btree
  add_index "event_invitations", ["token"], name: "index_event_invitations_on_token", using: :btree

  create_table "events", force: true do |t|
    t.integer  "user_id"
    t.string   "event_day"
    t.string   "event_time"
    t.string   "genre"
    t.string   "postal_code"
    t.string   "balanced_debit_id"
    t.integer  "charged_price"
    t.string   "currency"
    t.text     "address"
    t.string   "phone"
    t.text     "additionals"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_invitations_count"
    t.datetime "event_at"
    t.integer  "coupon_id"
    t.integer  "coupon_price"
    t.string   "coupon_code"
  end

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
    t.boolean  "system_message"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["receiver_id"], name: "index_messages_on_receiver_id", using: :btree
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id", using: :btree

  create_table "pictures", force: true do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "image"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
    t.string   "picture"
    t.text     "caption"
  end

  add_index "pictures", ["position"], name: "index_pictures_on_position", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.string   "name"
    t.text     "title"
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "artist_type",                                        default: 0
    t.string   "location"
    t.string   "currency"
    t.text     "additionals"
    t.string   "avatar"
    t.text     "payout"
    t.string   "slug"
    t.boolean  "featured",                                           default: false
    t.decimal  "latitude",                 precision: 14, scale: 11
    t.decimal  "longitude",                precision: 14, scale: 11
    t.string   "country_long"
    t.string   "country_short"
    t.string   "balanced_bank_account_id"
    t.string   "wizard_state"
    t.datetime "published_at"
  end

  add_index "profiles", ["featured"], name: "index_profiles_on_featured", using: :btree
  add_index "profiles", ["latitude"], name: "index_profiles_on_latitude", using: :btree
  add_index "profiles", ["longitude"], name: "index_profiles_on_longitude", using: :btree
  add_index "profiles", ["slug"], name: "index_profiles_on_slug", unique: true, using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "reviews", force: true do |t|
    t.integer  "author_id"
    t.integer  "profile_id"
    t.integer  "artist_id"
    t.text     "body"
    t.integer  "rate",       limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["artist_id"], name: "index_reviews_on_artist_id", using: :btree
  add_index "reviews", ["author_id"], name: "index_reviews_on_author_id", using: :btree
  add_index "reviews", ["profile_id"], name: "index_reviews_on_profile_id", using: :btree

  create_table "search_queries", force: true do |t|
    t.string  "location"
    t.text    "content"
    t.integer "counter",  default: 0
  end

  add_index "search_queries", ["location"], name: "index_search_queries_on_location", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "salutation"
    t.string   "mobile_nr"
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
    t.string   "balanced_customer_id"
    t.string   "role"
    t.text     "about"
    t.boolean  "newsletter_subscribed",  default: false
    t.string   "balanced_card_id"
    t.text     "error_log"
    t.string   "provider"
    t.string   "uid"
    t.datetime "mobile_nr_confirmed_at"
    t.boolean  "verified",               default: false
    t.string   "otp_secret_key"
    t.string   "mobile_nr_country_code"
    t.string   "full_name"
    t.string   "birthday"
    t.text     "additionals"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
