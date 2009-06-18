class AddPaidAtToReplies < ActiveRecord::Migration
  def self.up
    add_column :event_replies, :paid_at, :datetime
  end

  def self.down
    remove_column :event_replies, :paid_at
  end
end
