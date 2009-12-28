class AddBounceAddressToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :bounce_address, :string
  end

  def self.down
    remove_column :events, :bounce_address
  end
end
