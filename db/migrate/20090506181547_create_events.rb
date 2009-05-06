class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.datetime :deadline
      t.integer :max_guests, :null => false, :default => 0
      t.string :ref_prefix, :null => false, :default => ""

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
