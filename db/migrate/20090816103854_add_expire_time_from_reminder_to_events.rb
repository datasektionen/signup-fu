class AddExpireTimeFromReminderToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :expire_time_from_reminder, :integer
  end

  def self.down
    remove_column :events, :expire_time_from_reminder
  end
end
