class AddAuthNameToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :auth_name, :string
    
    Event.all.each do |e|
      e.password = 'kaka1234'
      e.auth_name = Authlogic::Random.friendly_token
      e.save!
    end
  end

  def self.down
    remove_column :events, :auth_name
  end
end
