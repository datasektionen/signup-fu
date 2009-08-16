class AddRemindedAtToEventReplies < ActiveRecord::Migration
  def self.up
    add_column :event_replies, :reminded_at, :datetime
  end

  def self.down
    remove_column :event_replies, :reminded_at
  end
end
