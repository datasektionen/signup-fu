class MakeNullableColumnsNullable < ActiveRecord::Migration
  def self.up
    change_column 'custom_field_values', 'created_at', :datetime, :null => true
    change_column 'custom_field_values', 'updated_at', :datetime, :null => true
    change_column 'custom_fields', 'created_at', :datetime, :null => true
    change_column 'custom_fields', 'updated_at', :datetime, :null => true
    change_column 'delayed_jobs', 'created_at', :datetime, :null => true
    change_column 'delayed_jobs', 'updated_at', :datetime, :null => true
    change_column 'delayed_jobs', 'failed_at', :datetime, :null => true
    change_column 'delayed_jobs', 'locked_at', :datetime, :null => true
    change_column 'delayed_jobs', 'run_at', :datetime, :null => true
    change_column 'events', 'created_at', :datetime, :null => true
    change_column 'events', 'updated_at', :datetime, :null => true
    change_column 'events', 'deadline', :datetime, :null => false
    change_column 'food_preferences', 'created_at', :datetime, :null => true
    change_column 'food_preferences', 'updated_at', :datetime, :null => true
    change_column 'mail_templates', 'created_at', :datetime, :null => true
    change_column 'mail_templates', 'updated_at', :datetime, :null => true
    change_column 'replies', 'created_at', :datetime, :null => true
    change_column 'replies', 'updated_at', :datetime, :null => true
    change_column 'replies', 'paid_at', :datetime, :null => true
    change_column 'replies', 'reminded_at', :datetime, :null => true
    change_column 'ticket_types', 'created_at', :datetime, :null => true
    change_column 'ticket_types', 'updated_at', :datetime, :null => true
    change_column 'users', 'created_at', :datetime, :null => true
    change_column 'users', 'updated_at', :datetime, :null => true
    change_column 'users', 'remember_created_at', :datetime, :null => true
    change_column 'users', 'current_sign_in_at', :datetime, :null => true
    change_column 'users', 'last_sign_in_at', :datetime, :null => true
  end

  def self.down
  end
end
