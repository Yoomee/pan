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
# It's strongly recommended to check this file into your version control system.

<<<<<<< HEAD
ActiveRecord::Schema.define(:version => 20120416142106) do
=======
ActiveRecord::Schema.define(:version => 20120416155053) do
>>>>>>> 4bafa8769be5ca06f5107512fb120689cae6258d

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.integer  "parent_id"
    t.string   "slug"
    t.string   "title"
    t.string   "short_title"
    t.text     "text"
    t.boolean  "published",   :default => false
    t.integer  "position"
    t.string   "view_name",   :default => "basic"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["parent_id"], :name => "index_pages_on_parent_id"

  create_table "permalinks", :force => true do |t|
    t.string   "path"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.boolean  "active",        :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permalinks", ["path"], :name => "index_permalinks_on_path"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "target_id"
    t.string   "target_type"
    t.text     "text"
    t.string   "image_uid"
    t.string   "video_url"
    t.string   "video_title"
    t.text     "video_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["target_id", "target_type"], :name => "index_posts_on_target_id_and_target_type"

  create_table "promoters", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "snippets", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "name"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "snippets", ["item_type", "item_id"], :name => "index_snippets_on_item_type_and_item_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.text     "bio"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "venues", :force => true do |t|
    t.integer  "promoter_id"
    t.string   "name"
    t.text     "description"
    t.string   "image_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
