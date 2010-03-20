class CreateCustomFields < ActiveRecord::Migration
  def self.up
    create_table :custom_fields do |t|
      t.integer :event_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_fields
  end
end
