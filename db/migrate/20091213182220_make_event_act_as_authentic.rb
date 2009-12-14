class MakeEventActAsAuthentic < ActiveRecord::Migration
  def self.up
    add_column :events, :encrypted_password, :string, :null => false, :default => ""
    add_column :events, :persistence_token, :string
    
    Event.reset_column_information 
    
    Event.all.each do |event|
      begin
        event.password = event.password_confirmation = 'kaka1234'
        event.save!
      rescue => e
        puts "#{event.name} (#{event.id}) is defective:"
        puts e.message
      end
    end
  end

  def self.down
    remove_column :events, :encrypted_password
    remove_column :events, :persistence_token
  end
end
