class CreateEventReplies < ActiveRecord::Migration
  def self.up
    create_table :event_replies do |t|
      t.integer :event_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :event_replies
  end
end
