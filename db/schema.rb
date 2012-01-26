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

ActiveRecord::Schema.define(:version => 20120126175439) do

  create_table "custom_field_values", :force => true do |t|
    t.integer   "reply_id"
    t.integer   "custom_field_id"
    t.string    "value"
    t.timestamp "created_at",      :null => false
    t.timestamp "updated_at",      :null => false
  end

  create_table "custom_fields", :force => true do |t|
    t.integer   "event_id"
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",   :default => 0
    t.integer   "attempts",   :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at",                    :null => false
    t.timestamp "locked_at",                 :null => false
    t.timestamp "failed_at",                 :null => false
    t.string    "locked_by"
    t.timestamp "created_at",                :null => false
    t.timestamp "updated_at",                :null => false
  end

  create_table "events", :force => true do |t|
    t.string    "name"
    t.text      "description"
    t.timestamp "date",                                         :null => false
    t.timestamp "deadline",                                     :null => false
    t.integer   "max_guests",                :default => 0,     :null => false
    t.string    "ref_prefix",                :default => ""
    t.timestamp "created_at",                                   :null => false
    t.timestamp "updated_at",                                   :null => false
    t.integer   "payment_time"
    t.text      "signup_message"
    t.integer   "expire_time_from_reminder"
    t.string    "template"
    t.boolean   "getting_started_dismissed", :default => false, :null => false
    t.text      "terms"
    t.string    "bounce_address"
    t.boolean   "require_pid",               :default => false, :null => false
    t.boolean   "use_food_preferences",      :default => true,  :null => false
    t.integer   "user_id",                                      :null => false
    t.string    "slug"
  end

  create_table "food_preferences", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "food_preferences_replies", :id => false, :force => true do |t|
    t.integer "food_preference_id", :null => false
    t.integer "reply_id"
  end

  create_table "mail_templates", :force => true do |t|
    t.integer   "event_id"
    t.string    "name"
    t.text      "body"
    t.string    "subject"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "replies", :force => true do |t|
    t.integer   "event_id"
    t.string    "name"
    t.string    "email"
    t.text      "food"
    t.text      "comments"
    t.timestamp "created_at",     :null => false
    t.timestamp "updated_at",     :null => false
    t.integer   "ticket_type_id"
    t.datetime  "paid_at"
    t.datetime  "reminded_at"
    t.string    "payment_state",  :null => false
    t.string    "guest_state",    :null => false
    t.string    "pid"
  end

  create_table "ticket_types", :force => true do |t|
    t.integer   "event_id"
    t.string    "name"
    t.integer   "price"
    t.timestamp "created_at", :null => false
    t.timestamp "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string    "email",                               :default => ""
    t.string    "encrypted_password",   :limit => 128, :default => ""
    t.string    "password_salt",                       :default => ""
    t.string    "reset_password_token"
    t.string    "remember_token"
    t.timestamp "remember_created_at",                                    :null => false
    t.integer   "sign_in_count",                       :default => 0
    t.timestamp "current_sign_in_at",                                     :null => false
    t.timestamp "last_sign_in_at",                                        :null => false
    t.string    "current_sign_in_ip"
    t.string    "last_sign_in_ip"
    t.boolean   "admin",                               :default => false, :null => false
    t.timestamp "created_at",                                             :null => false
    t.timestamp "updated_at",                                             :null => false
    t.string    "name"
  end

end
