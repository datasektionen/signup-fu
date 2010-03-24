class ChangeForeignKeysToUseReplyIdInsteadOfEventReplyId < ActiveRecord::Migration
  def self.up
    rename_column :event_replies_food_preferences, :event_reply_id, :reply_id
    rename_table :event_replies_food_preferences, :food_preferences_replies
    rename_column :custom_field_values, :event_reply_id, :reply_id
  end

  def self.down
  end
end
