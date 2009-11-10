class ChangeStateColumnsOnEventReplies < ActiveRecord::Migration
  def self.up
    change_table :event_replies do |t|
      t.remove :aasm_state
      t.string :payment_state
      t.string :guest_state
    end
  end

  def self.down
  end
end
