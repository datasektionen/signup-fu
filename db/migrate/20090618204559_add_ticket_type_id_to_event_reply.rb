class AddTicketTypeIdToEventReply < ActiveRecord::Migration
  def self.up
    add_column :event_replies, :ticket_type_id, :integer
  end

  def self.down
    remove_column :event_replies, :ticket_type_id
  end
end
