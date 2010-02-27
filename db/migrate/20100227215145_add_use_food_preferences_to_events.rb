class AddUseFoodPreferencesToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :use_food_preferences, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :events, :use_food_preferences
  end
end
