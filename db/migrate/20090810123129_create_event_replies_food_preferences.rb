class CreateEventRepliesFoodPreferences < ActiveRecord::Migration
  def self.up
    create_table :event_replies_food_preferences, :id => false do |t|
      t.integer :food_preference_id
      t.integer :event_reply_id
    end
  end

  def self.down
    drop_table :event_replies_food_preferences
  end
end
