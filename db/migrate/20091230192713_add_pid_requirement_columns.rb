class AddPidRequirementColumns < ActiveRecord::Migration
  def self.up
    add_column :events, :require_pid, :boolean, :default => false, :null => false
    add_column :event_replies, :pid, :string
  end

  def self.down
    remove_column :event_replies, :pid
    remove_column :events, :require_pid
  end
end
