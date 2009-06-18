class CreateEventPrices < ActiveRecord::Migration
  def self.up
    create_table :event_prices do |t|
      t.integer :event_id
      t.string :name
      t.integer :price

      t.timestamps
    end
  end

  def self.down
    drop_table :event_prices
  end
end
