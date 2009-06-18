class CreateMailTemplates < ActiveRecord::Migration
  def self.up
    create_table :mail_templates do |t|
      t.integer :event_id
      t.string :name
      t.text :body
      t.string :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :mail_templates
  end
end
