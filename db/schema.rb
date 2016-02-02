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

ActiveRecord::Schema.define(version: 20160202052940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "author"
    t.string   "email"
    t.text     "body"
    t.integer  "parent_comment"
    t.integer  "score"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "content_id"
  end

  add_index "comments", ["content_id"], name: "index_comments_on_content_id", using: :btree

  create_table "contents", force: :cascade do |t|
    t.string   "title"
    t.integer  "author"
    t.text     "body"
    t.string   "image"
    t.integer  "external_id",   limit: 8
    t.string   "external_link"
    t.string   "kind"
    t.string   "rating"
    t.string   "location"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal"
    t.string   "ip"
    t.string   "latitude"
    t.string   "longitude"
    t.boolean  "is_active"
    t.datetime "created"
    t.datetime "updated"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "slug"
    t.boolean  "has_comments"
    t.boolean  "is_sticky",               default: false
  end

  add_index "contents", ["slug"], name: "index_contents_on_slug", using: :btree

  create_table "projects", force: :cascade do |t|
    t.integer  "author"
    t.string   "title"
    t.string   "image"
    t.text     "body"
    t.integer  "position"
    t.string   "technologies"
    t.string   "github_link"
    t.string   "project_link"
    t.date     "start"
    t.date     "end"
    t.string   "location"
    t.datetime "created"
    t.datetime "edited"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "user_providers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_providers", ["user_id"], name: "index_user_providers_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "username",               default: "", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.text     "bio"
    t.string   "avatar"
    t.string   "twitter_avatar"
    t.integer  "rating"
    t.integer  "number_followers"
    t.integer  "number_statuses"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.string   "account_type"
    t.boolean  "admin"
    t.string   "location"
    t.string   "address"
    t.string   "street"
    t.string   "city"
    t.string   "postal"
    t.string   "longitude"
    t.string   "latitude"
    t.datetime "created"
    t.datetime "edited"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain"
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "comments", "contents"
end
