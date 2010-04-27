# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100324201047) do

  create_table "custom_field_values", :force => true do |t|
    t.integer  "reply_id"
    t.integer  "custom_field_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "custom_fields", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "date"
    t.datetime "deadline"
    t.integer  "max_guests",                :default => 0,     :null => false
    t.string   "ref_prefix",                :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payment_time"
    t.text     "signup_message"
    t.integer  "expire_time_from_reminder"
    t.string   "template"
    t.boolean  "getting_started_dismissed", :default => false, :null => false
    t.text     "terms"
    t.string   "bounce_address"
    t.boolean  "require_pid",               :default => false, :null => false
    t.boolean  "use_food_preferences",      :default => true,  :null => false
    t.integer  "user_id"
  end

  create_table "food_preferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "food_preferences_replies", :id => false, :force => true do |t|
    t.integer "food_preference_id"
    t.integer "reply_id"
  end

  create_table "mail_templates", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.text     "body"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.string   "email"
    t.text     "food"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ticket_type_id"
    t.datetime "paid_at"
    t.datetime "reminded_at"
    t.string   "payment_state",  :null => false
    t.string   "guest_state",    :null => false
    t.string   "pid"
  end

  create_table "ticket_types", :force => true do |t|
    t.integer  "event_id"
    t.string   "name"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                  :null => false
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",               :default => false, :null => false
  end

end
