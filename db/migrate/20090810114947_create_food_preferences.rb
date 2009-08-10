class CreateFoodPreferences < ActiveRecord::Migration
  def self.up
    create_table :food_preferences do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :food_preferences
  end
end
