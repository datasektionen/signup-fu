class CreateTicketTypes < ActiveRecord::Migration
  def self.up
    create_table :ticket_types do |t|
      t.integer :event_id
      t.string :name
      t.integer :price

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_types
  end
end
