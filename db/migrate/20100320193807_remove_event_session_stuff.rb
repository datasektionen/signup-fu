class RemoveEventSessionStuff < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.integer :user_id
      t.remove :auth_name
      t.remove :encrypted_password
      t.remove :persistence_token
      
    end
  end

  def self.down
    change_table :events do |t|
    end
  end
end
