class AddPriceIdToEventReply < ActiveRecord::Migration
  def self.up
    add_column :event_replies, :event_price_id, :integer
  end

  def self.down
    remove_column :event_replies, :event_price_id
  end
end
