class AddSignupMessageToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :signup_message, :text
  end

  def self.down
    remove_column :events, :signup_message
  end
end
