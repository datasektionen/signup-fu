class AddPaymentTimeToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :payment_time, :integer
  end

  def self.down
    remove_column :events, :payment_time
  end
end
