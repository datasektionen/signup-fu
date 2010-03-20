class CreateCustomFieldValues < ActiveRecord::Migration
  def self.up
    create_table :custom_field_values do |t|
      t.integer :event_reply_id
      t.integer :custom_field_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :custom_field_values
  end
end
