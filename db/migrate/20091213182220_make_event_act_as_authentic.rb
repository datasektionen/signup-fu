class MakeEventActAsAuthentic < ActiveRecord::Migration
  def self.up
    add_column :events, :encrypted_password, :string, :null => false, :default => ""
    add_column :events, :persistence_token, :string
  end

  def self.down
    remove_column :events, :encrypted_password
    remove_column :events, :persistence_token
  end
end
