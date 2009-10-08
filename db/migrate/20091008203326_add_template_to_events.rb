class AddTemplateToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :template, :string
  end

  def self.down
    remove_column :events, :template
  end
end
