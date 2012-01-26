class MakeNullableColumnsNullable < ActiveRecord::Migration
  def self.up
    change_column 'replies', 'paid_at', :datetime, :null => true
    change_column 'replies', 'reminded_at', :datetime, :null => true
  end

  def self.down
  end
end
