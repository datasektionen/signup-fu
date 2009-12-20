class AddTermsToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :terms, :text
  end

  def self.down
    remove_column :events, :terms
  end
end
