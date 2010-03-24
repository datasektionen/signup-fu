class RenameEventRepliesToReplies < ActiveRecord::Migration
  
  class EventReply < ActiveRecord::Base
    
  end
  def self.up
    rename_table :event_replies, :replies
  end

  def self.down
    remove_column :users, :admin
  end
end
