class FixStateColumnsOnReplies < ActiveRecord::Migration
  def self.up
    change_column :event_replies, :guest_state, :string, :null => false
    change_column :event_replies, :payment_state, :string, :null => false
  end

  def self.down
    change_column :event_replies, :guest_state, :string
  end
end
